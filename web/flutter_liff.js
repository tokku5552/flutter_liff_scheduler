async function init(config){
    console.log("init called")
    console.log(`liff ID: ${config["liffID"]}`)
    await liff.init({
        liffId: config["liffID"],
        withLoginOnEternalBrowser: true,
    })
    .then(() => {
        config["successCallback"]()
     })
     .catch((err) => {
        config["errorCallback"](err)
     });
}

function getLiffID(){
    return liff.id
}

async function getUserID(){
    console.log("getUserID called")
    console.log(`liff ID is ${liff.id}`)
   const profile = await liff.getProfile()
   console.log(`profile: ${profile}`)
   return profile["userId"]
}

async function getGroupID(){
    console.log("getGroupID called")
    console.log(`liff ID is ${liff.id}`)
   const context = await liff.getContext()
   console.log(`context: ${JSON.stringify(context, null, 2)}`)
   return context["groupId"]
}

async function getAccessToken(){
    console.log("getAccessToken called")
    console.log(`liff ID is ${liff.id}`)
    return await liff.getAccessToken()
}