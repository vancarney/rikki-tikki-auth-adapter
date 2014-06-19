RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI || module.parent.exports
Util = RikkiTikkiAPI.Util
class AuthConfigLoader extends RikkiTikkiAPI.base_classes.AbstractLoader
  constructor:(path)->
    AuthConfigLoader.__super__.constructor.call @, null
    @__path = path
  load:(callback)->
    if fs.existsSync @__path
      AuthConfigLoader.__super__.load.call @, (e, data)=>
        if data?
          @__data = JSON.parse data
          # @__data.provider = Util.File.name @__path 
        callback? e, @__data
    else
      callback? new Error "Could not find config file at '#{@__path}'"
  getEnvironment:(env)->
    @__data?[env] || null
module.exports = AuthConfigLoader