RikkiTikkiAPI   = module.parent.exports.RikkiTikkiAPI || module.parent.exports
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
Util            = RikkiTikkiAPI.Util
fs              = require 'fs'
path            = require 'path'
{_}             = require 'underscore'
AuthConfig      = require './AuthConfigLoader'
class AuthConfigManager extends RikkiTikkiAPI.base_classes.Singleton
  # holder for `schemas`
  __configs:{}
  ## `class` constructor
  constructor:->
    # defines `__path`
    @__path = "#{RikkiTikkiAPI.getOptions().auth_config_path}"
    # invokes `load`
    @load()
  ## load()
  #> Shallowly Traverses Schema Directory and loads found Schemas that are not marked as hidden with a prepended `_` or `.`
  load:(callback)->
    try
      # attempts to get stats on the file
      stat = fs.statSync @__path
    catch e
      throw new Error e
    # tests for directory
    if stat?.isDirectory()
      errors = []
      # walk this directory
      for file in fs.readdirSync @__path
        # skip files that are declared as hidden
        continue if file.match /^(_|\.)+/
        # creates new SchemaLoader and assign to __configs hash
        (@__configs ?= {})[n = Util.File.name file] = new AuthConfig path.normalize "#{@__path}#{path.sep}#{file}"
        @__configs[n].load (e,s)=>
          return errors.push e if e?
      callback?.apply @, if errors.length then [errors,null] else [null,true]
AuthConfigManager.getInstance = ->
  @__instance ?= new AuthConfigManager
module.exports = AuthConfigManager