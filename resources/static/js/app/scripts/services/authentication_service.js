/**
 * Created by pozpl on 16.12.13.
 */

angular.module('GeoHashingApp').factory('AuthenticationService', [function () {
    var userIsAuthenticated = false;
    var lastUnauthenticatedState = null;

    this.setLoggedIn = function (value) {
        userIsAuthenticated = value;
    };

    this.isLoggedIn = function () {
        return userIsAuthenticated;
    };

    this.getLastUnauthenticatedState = function(){
        return lastUnauthenticatedState;
    }

    this.setLastUnauthenticatedState = function(value){
        lastUnauthenticatedState = value;
    }
}]
);
