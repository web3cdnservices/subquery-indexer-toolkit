#!/bin/node
//# @TODO import .env

let _=require('lodash');

(async()=>{


  let projects_list_query= await fetch("http://indexer_coordinator:8000/graphql", {
    "headers": {
      "content-type": "application/json",
    },
    "body": "{\"operationName\":null,\"variables\":{},\"query\":\"{\\n  getProjects {\\n    id\\n    status\\n    details {\\n      name\\n      image\\n      version\\n    }\\n    metadata {\\n      lastProcessedHeight\\n      lastProcessedTimestamp\\n      targetHeight\\n      chain\\n      specName\\n      indexerHealthy\\n      indexerNodeVersion\\n      queryNodeVersion\\n      indexerStatus\\n      queryStatus\\n    }\\n    payg {\\n      id\\n      price\\n      expiration\\n    }\\n  }\\n}\\n\"}",
    "method": "POST"
  });
  let project_list=await projects_list_query.json();


let resultArr = project_list.data.getProjects.map((project)=>{

let  textStatusToInt=(name)=>{
  if (name==='HEALTHY') return 100;
  else if (name==='INDEXING') return 50;
  else if (name==='UNHEALTHY') return 10;
  else return 0;
}
  return {"labels":
      {"env":"indexer-projects","displayName": project.details.name,"deploymentId":String(project.id)},

    "results": {
      "status": project.status,
      "lastProcessedHeight": project.metadata.lastProcessedHeight,
      "targetHeight": project.metadata.targetHeight,
      "syncLag": parseInt(project.metadata.targetHeight) - parseInt(project.metadata.lastProcessedHeight),
      "lastProcessedTimestampDiff": (parseInt(new Date().valueOf())-parseInt(project.metadata.lastProcessedTimestamp)),
      "lastProcessedTimestamp": project.metadata.lastProcessedTimestamp,
      "processingTimeLag": (Date.now()-parseInt(project.metadata.lastProcessedTimestamp)) / 1000,
      "indexerHealthy": (project.metadata.indexerHealthy) ? 1 : 0,
      "indexerNodeVersion": parseInt(project.metadata.indexerNodeVersion.replace(/\./g,"")),
      "queryNodeVersion": parseInt(project.metadata.queryNodeVersion.replace(/\./g,"")),
      "indexerStatus": textStatusToInt(project.metadata.indexerStatus),
      "queryStatus": textStatusToInt(project.metadata.queryStatus), 
      "hasActivePayg":(project.payg.expiration>0) ? 1 : 0

  } }
})

  console.log(JSON.stringify(resultArr));
  process.exit(0)

})();
