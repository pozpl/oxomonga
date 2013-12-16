'use strict';

angular.module('GeoHashingApp')
    .controller('LoginCtrl', ['$scope', '$rootScope', '$http', '$state' ,'AuthenticationService'
        , function ($scope, $rootScope, $http, $state, AuthenticationService) {

            $scope.userName = '';
            $scope.password = '';

            AuthenticationService.setLoggedIn(true);
            if(AuthenticationService.getLastUnauthenticatedState()){
                $state.go(AuthenticationService.getLastUnauthenticatedState());
            }

        }
    ]);


