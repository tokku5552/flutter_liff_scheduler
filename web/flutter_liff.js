async function init(config){
    console.log("init called")
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
   const profile = await liff.getProfile()
   return profile["userId"]
}

async function getGroupId(){
    console.log("getGroupId called")
   const context = await liff.getContext()
   return context["groupId"]
}

async function getAccessToken(){
    console.log("getAccessToken called")
    return await liff.getAccessToken()
}