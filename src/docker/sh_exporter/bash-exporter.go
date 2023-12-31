package main

import (
	// "encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strings"
	"sync"
	"time"

	"github.com/bash-exporter/v2/pkg/run"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
	verbMetrics *prometheus.GaugeVec
)

func main() {
	addr := flag.String("web.listen-address", ":9300", "Address on which to expose metrics")
	interval := flag.Int("interval", 300, "Interval for metrics collection in seconds")
	path := flag.String("path", "/scripts", "path to directory with bash scripts")
	labels := flag.String("labels", "hostname,env", "additioanal labels")
	prefix := flag.String("prefix", "bash", "Prefix for metrics")
	debug := flag.Bool("debug", false, "Debug log level")
	flag.Parse()

	var labelsArr []string

	labelsArr = strings.Split(*labels, ",")
	labelsArr = append(labelsArr, "verb",  "job")

	verbMetrics = prometheus.NewGaugeVec(
		prometheus.GaugeOpts{
			Name: fmt.Sprintf("%s", *prefix),
			Help: "bash exporter metrics",
		},
		// []string{"verb", "job"},
		labelsArr,
	)
	prometheus.MustRegister(verbMetrics)

	files, err := ioutil.ReadDir(*path)
	if err != nil {
		log.Fatal(err)
	}

	var names []string
	for _, f := range files {
		if f.Name()[0:1] != "."  {
			if f.IsDir() == false {
				names = append(names, f.Name())
//				log.Println(string(f.Name()))
			}
		}
	}

	http.Handle("/metrics", promhttp.Handler())
	go Run(int(*interval), *path, names, labelsArr, *debug)
	log.Fatal(http.ListenAndServe(*addr, nil))
}

func Run(interval int, path string, names []string, labelsArr []string, debug bool) {
	for {
		var wg sync.WaitGroup
		oArr := []*run.Output{}
		wg.Add(len(names))
		for _, name := range names {
			o := run.Output{}

			o.Job = strings.Split(name, ".")[0]
			oArr = append(oArr, &o)
			thisPath := path + "/" + name
			p := run.Params{UseWg: true, Wg: &wg, Path: &thisPath}

			go o.RunJob(&p)

		}
		wg.Wait()

//		 if debug == true {
//		 	ser, err := json.Marshal(o)
//		 	if err != nil {
//		 		log.Println(err)
//		 	}
//		 	log.Println(string(ser))
//		 }
		verbMetrics.Reset()


                for _, o := range oArr {

//		    if o.Schema {
                        for _, rowItem := range o.Schema {
				for metric, value := range rowItem.Results {
                                for _, label := range labelsArr {
                                        if _, ok := rowItem.Labels[label]; !ok {
                                           rowItem.Labels[label] = ""
                                        }
                                }
                                rowItem.Labels["verb"] = metric
                                rowItem.Labels["job"] = o.Job
                                fmt.Println(rowItem.Labels)
                                verbMetrics.With(prometheus.Labels(rowItem.Labels)).Set(float64(value))
				}
			    }
//		}
            }

		time.Sleep(time.Duration(interval) * time.Second)
	}
}
