(function() {

  $(function() {
    var App, HomeScreen, Router;
    window.JST = {
      'screen': $('#screen-template').html()
    };
    HomeScreen = Tres.Screen.extend({
      template: JST['screen']
    });
    Router = Tres.Router.extend({
      routes: {
        '': 'home',
        home: function() {
          App.HomeScreen.embed();
          return App.HomeScreen.activate();
        }
      }
    });
    App = {
      Device: new Tres.Device,
      HomeScreen: new HomeScreen,
      Router: new Router
    };
    return Backbone.history.start({
      pushState: true
    });
  });

}).call(this);