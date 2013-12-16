'use strict';

angular.module('GeoHashingApp')
    .controller('LoginCtrl', ['$scope', '$rootScope', '$http', '$state' , 'AuthenticationService'
        , function ($scope, $rootScope, $http, $state, AuthenticationService) {

            var showLoginPage = function () {
                $scope.userName = '';
                $scope.password = '';
            };

            showLoginPage();

            $scope.submit = function () {
                AuthenticationService.setLoggedIn(true);
                if (AuthenticationService.getLastUnauthenticatedState()) {
                    $state.go(AuthenticationService.getLastUnauthenticatedState());
                } else{
                    $state.go('main_state');
                }
            };

        }
    ]);


