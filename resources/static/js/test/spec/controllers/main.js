'use strict';

describe('Controller: MarkersListCtrl', function () {

  // load the controller's module
  beforeEach(module('GeoHashingApp'));

  var MarkersList,
    scope;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller, $rootScope) {
    scope = $rootScope.$new();
    MarkersList = $controller('MarkersListCtrl', {
      $scope: scope
    });
  }));

  it('should attach a list of awesomeThings to the scope', function () {
    expect(scope.awesomeThings.length).toBe(3);
  });
});
