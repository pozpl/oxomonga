/**
 * Created by pozpl on 16.12.13.
 */

angular.module('GeoHashingApp').service('AuthenticationService', function(){
    var userIsAuthenticated = false;

    this.setLoggedIn = function(value){
        userIsAuthenticated = value;
    };

    this.isLoggedIn = function(){
        return userIsAuthenticated;
    };
});
