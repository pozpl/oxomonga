define( "dojo/_base/declare", "dojo/_base/array",     "dojo/dom-class",
	"dojo/dom-attr", "dojo/io/script", "dojo/query",
    function declare(declare, array, domClass, domAttr, script, query) {
        return declare('Markers.MarkerEditForm', {
            loadFormContent: function () {
                var formNodes = query('#markers-edit-form');
                if (formNodes && formNodes.length > 0) {
                    var form = formNodes[0];

                }
            }
        });

    }
);
