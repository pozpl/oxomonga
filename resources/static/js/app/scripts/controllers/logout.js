'use strict';

angular.module('GeoHashingApp')
    .controller('LogOutCtrl', ['$scope', '$http', '$state' , 'AuthenticationService'
        , function ($scope, $http, $state, AuthenticationService) {
            var submitLogOut = function () {
                $http({method: 'GET', url: '/logout'}).
                    success(function (data, status, headers, config) {
                        if (data && data.status == 'ok') {
                            AuthenticationService.setLoggedIn(false);
                            AuthenticationService.setUserId(0);

                            $state.go('main_state');
                        }
                    }).
                    error(function (data, status, headers, config) {
                      //TODO write some inspiration code here
                    });


            };

            submitLogOut();

        }
    ]);


