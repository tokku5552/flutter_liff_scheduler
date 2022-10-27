async function init(config){
    console.log("init called")
    console.log(`liff Id: ${config["liffId"]}`)
    await liff.init({
        liffId: config["liffId"],
        withLoginOnEternalBrowser: true,
    })
    .then(() => {
        config["successCallback"]()
     })
     .catch((err) => {
        config["errorCallback"](err)
     });
}

function getLiffId(){
    return liff.id
}

async function getUserId(){
    console.log("getUserId called")
    console.log(`liff Id is ${liff.id}`)
   const profile = await liff.getProfile()
   console.log(`profile: ${profile}`)
   return profile["userId"]
}

async function getGroupId(){
    console.log("getGroupId called")
    console.log(`liff Id is ${liff.id}`)
   const context = await liff.getContext()
   console.log(`context: ${JSON.stringify(context, null, 2)}`)
   return context["groupId"]
}

async function getAccessToken(){
    console.log("getAccessToken called")
    console.log(`liff Id is ${liff.id}`)
    return await liff.getAccessToken()
}