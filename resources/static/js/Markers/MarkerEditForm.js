define( ["dojo/_base/declare", "dojo/query", 'dojo/dom-attr'],
    function (declare, query, domAttr) {
        return declare(null,{

            constructor: function(args){
            },

            loadFormContent: function () {
                var formNodes = query('#markers-edit-form');
                if (formNodes && formNodes.length > 0) {
                    var form = formNodes[0];
                    var loadContentUrl = domAttr.get(form, 'data-url');
                    console.log(loadContentUrl);
                }
            }
        });

    }
);

