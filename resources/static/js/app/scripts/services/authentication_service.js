/**
 * Created by pozpl on 16.12.13.
 */

angular.module('GeoHashingApp').service('AuthenticationService', function(){
    var userIsAuthenticated = false;

    this.setUserAuthenticated = function(value){
        userIsAuthenticated = value;
    };

    this.getUserAuthenticated = function(){
        return userIsAuthenticated;
    };
});
