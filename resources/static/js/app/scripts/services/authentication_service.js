/**
 * Created by pozpl on 16.12.13.
 */

angular.module('GeoHashingApp').factory('AuthenticationService', ['$cookies', function ($cookies) {
    var userIsAuthenticated = false;
    var lastUnauthenticatedState = null;
    var lastUnauthenticatedStateParams = null;
    var userId = null;

    return {
        setLoggedIn: function (value) {
            userIsAuthenticated = value;
            $cookies.loggedIn = value ? "1" : "0";
        },

        isLoggedIn: function () {
            if($cookies.loggedIn){
                userIsAuthenticated = true;
            }

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
        },

        setUserId : function(userId){
            this.userId = userId;
            $cookies.userId = userId;
        },

        getUserId : function(){
            if(! userId){
                userId = $cookies.userId;
            }
            return userId;
        }
    };
}]
);
