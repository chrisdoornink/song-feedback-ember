@SF = Ember.Application.create()

SF.Router.map ->
  @resource 'login'
  @resource 'logout'
  @resource 'songs'
  @resource 'song', {path:'/songs/:song_id'}
  @resource 'my-songs', {path:'/my-songs'}
  @resource 'upload'
  @resource 'settings'


SF.ApplicationRoute = Ember.Route.extend
  enter: ->
    SF.loginController.set('username', localStorage.getItem('username'))
    SF.loginController.set('password', localStorage.getItem('password'))
    SF.loginController.set('id', localStorage.getItem('id'))
    SF.loginController.tryLogin(true)

SF.LogoutRoute = Ember.Route.extend
  redirect: ->
    localStorage.clear()
    SF.loginController.set('content', {})
    SF.loginController.set('password', null)
    SF.loginController.set('username', null)
    SF.loginController.set('id', null)
    @transitionTo('index')

SF.MySongsRoute = Ember.Route.extend
  setupController: (controller, model) ->
    console.log(SF.loginController.get('id'))
    controller.set("songs", [])
    mysongs_model = []
    id = SF.loginController.get('id')
    if id then mysongs_model = SF.Song.findForUser(id) else @transitionTo('songs')
    console.log(controller)
    controller.set("songs", mysongs_model)

SF.SongsRoute = Ember.Route.extend
  setupController: (controller, model) ->
    controller.set("songs", [])
    songs_model = []
    songs_model = SF.Song.findAll()
    controller.set("songs", songs_model)

SF.SongRoute = Ember.Route.extend
  model: (params) ->  
    SF.Song.find(params.song_id)
  setupController: (controller, model) ->
    controller.set("content", model)
    