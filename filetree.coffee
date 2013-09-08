@Filetree = (I={}) ->
  Object.defaults I,
    files: []

  self = Model(I).observeAll()

  self.attrObservable "selectedFile"

  self.extend
    load: (fileData) ->
      files = Object.keys(fileData).sort().map (name) ->
        File fileData[name]

      self.files(files)

    data: ->
      self.files.map (file) ->
        path: file.filename()
        mode: "100644"
        content: file.content()
        type: "blob"

    hasUnsavedChanges: ->
      self.files().select (file) ->
        file.modified()
      .length

    # TODO: Use git trees and content shas to robustly manage changed state
    markSaved: ->
      self.files().each (file) ->
        file.modified(false)

  return self
