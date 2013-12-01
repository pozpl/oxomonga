'use strict';

angular.module('GeoHashingApp')
    .controller('EditMarkerCtrl', function ($scope, $rootScope, $route, $http) {

        $rootScope.textAngularOpts = {
            toolbar: [['h1', 'h2', 'h3', 'p', 'pre', 'bold', 'italics', 'ul', 'ol', 'redo', 'undo', 'clear'],['html', 'insertImage', 'insertLink']],
            classes: {
                toolbar: "btn-toolbar",
                toolbarGroup: "btn-group",
                toolbarButton: "btn btn-default",
                toolbarButtonActive: "active",
                textEditor: 'form-control',
                htmlEditor: 'form-control'
            }
        }

    });

