/**
 * Created by pozpl on 16.12.13.
 */

angular.module('GeoHashingApp').factory('AuthenticationService', [function () {
    var userIsAuthenticated = false;
    var lastUnauthenticatedState = null;
    var lastUnauthenticatedStateParams = null;
    return {
        setLoggedIn: function (value) {
            userIsAuthenticated = value;
        },

        isLoggedIn: function () {
            return userIsAuthenticated;
        },

        getLastUnauthenticatedState: function () {
            return lastUnauthenticatedState;
        },

        setLastUnauthenticatedState: function (value) {
            lastUnauthenticatedState = value;
        },

        setLastUnauthenticatedStateParams: function(value){
            lastUnauthenticatedStateParams = value;
        },

        getLastUnauthenticatedStateParams: function(){
            return lastUnauthenticatedStateParams;
        }
    };
}]
);
