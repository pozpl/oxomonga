'use strict';

angular.module('GeoHashingApp')
    .controller('EditMarkerCtrl', ['$scope', '$rootScope', '$state','$stateParams', '$http', '$upload', 'AuthenticationService',
        function ($scope, $rootScope, $state, $stateParams, $http, $upload, AuthenticationService) {

            $rootScope.textAngularOpts = {
                toolbar: [
                    ['h1', 'h2', 'h3', 'p', 'pre', 'bold', 'italics', 'ul', 'ol', 'redo', 'undo', 'clear'],
                    ['html', 'insertImage', 'insertLink']
                ],
                classes: {
                    toolbar: "btn-toolbar",
                    toolbarGroup: "btn-group",
                    toolbarButton: "btn btn-default",
                    toolbarButtonActive: "active",
                    textEditor: 'form-control',
                    htmlEditor: 'form-control'
                }
            };

            $scope.id = $stateParams.id;
            $scope.user = AuthenticationService.getUserId();
            $scope.latitude = '';
            $scope.longitude = '';
            $scope.description = '';
            $scope.images = [];

            var getMarker = function (markerId) {
                $http({method: 'GET', url: '/markers/get/marker/json/' + markerId}).
                    success(function (data, status, headers, config) {
                        if (data && data.id) {
                            showMarker(data);
                        }
                    }).
                    error(function (data, status, headers, config) {
                        // called asynchronously if an error occurs
                        // or server returns response with an error status.
                    });
            };

            if ($scope.id) {
                getMarker($scope.id);
            }

            $scope.submit = function (markerId) {
                var markerJson = {
                    'id': $scope.id,
                    'user': $scope.user,
                    'latitude': $scope.latitude,
                    'longitude': $scope.longitude,
                    'description': $scope.description,
                    'images' : $scope.images
                };

                $http({method: 'POST', url: '/markers/edit/json', data: markerJson }).
                    success(function (data, status, headers, config) {
                        if (data && data.id) {
                            if(markerId){
                                $state.go('show_marker', {'id' : data.id});
                            }else{
                                showMarker(data);
                            }
                        }
                    }).
                    error(function (data, status, headers, config) {
                        // called asynchronously if an error occurs
                        // or server returns response with an error status.
                    });
            };


            var showMarker = function (markerJson) {
                $scope.id = markerJson.id;
                $scope.user = markerJson.user;
                $scope.latitude = markerJson.latitude;
                $scope.longitude = markerJson.longitude;
                $scope.description = markerJson.description;
                $scope.images = markerJson.images;
            };


            $scope.onFileSelect = function ($files) {
                //$files: an array of files selected, each file has name, size, and type.
                for (var i = 0; i < $files.length; i++) {
                    var file = $files[i];
                    $scope.upload = $upload.upload({
                        url: '/marker/upload/images',
                        // method: POST or PUT,
                        // headers: {'headerKey': 'headerValue'}, withCredential: true,
                        data: {'marker_id': $scope.id},
                        file: file
                        // file: $files, //upload multiple files, this feature only works in HTML5 FromData browsers
                        /* set file formData name for 'Content-Desposition' header. Default: 'file' */
                        //fileFormDataName: myFile,
                        /* customize how data is added to formData. See #40#issuecomment-28612000 for example */
                        //formDataAppender: function(formData, key, val){}
                    }).progress(function (evt) {
                            console.log('percent: ' + parseInt(100.0 * evt.loaded / evt.total));
                        }).success(function (data, status, headers, config) {
                            // file is uploaded successfully
                            angular.forEach(data, function(image, key){
                                if($scope.images){
                                    $scope.images.push(image);
                                }else{
                                    $scope.images = [image];
                                }
                            });

                        });
                    //.error(...)
                    //.then(success, error, progress);
                }
            };

            $scope.deleteImage = function (imageId) {
                if ($scope.id) {
                    $http({method: 'POST', url: '/delete/marker/image',
                            data: {
                                'marker_id': $scope.id,
                                'image_id': imageId
                            }
                        }
                    ).
                        success(function (data, status, headers, config) {
                            if (data.status) {
                                var filteredImages = [];
                                angular.forEach($scope.images, function (image, key) {
                                    if (image.id != imageId) {
                                        this.push(image);
                                    }
                                }, filteredImages);

                                $scope.images = filteredImages;
                            }
                        }).
                        error(function (data, status, headers, config) {
                            // called asynchronously if an error occurs
                            // or server returns response with an error status.
                        });
                }
            }

        }]);

