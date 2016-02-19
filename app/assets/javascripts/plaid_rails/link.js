var plaidData = $("#plaid-data");
var linkHandler = Plaid.create({
    env: plaidData.data('env'),
    clientName: plaidData.data('client-name'),
    key: plaidData.data('key'),
    product: 'connect',
    webhook: plaidData.data('webhook'),
    onLoad: function () {
        // The Link module finished loading.
    },
    onSuccess: function (public_token, metadata) {
        // Send the public_token to your app server here.
        // The metadata object contains info about the institution the
        // user selected and the account ID, if selectAccount is enabled.
        $.ajax({
            type: 'POST',
            dataType: 'script',
            url: '/plaid/authenticate',
            data: {
                public_token: public_token,
                name: metadata.institution.name,
                type: metadata.institution.type,
                owner_type: plaidData.data('owner-type'),
                owner_id: plaidData.data('owner-id')
            }
        });
    },
    onExit: function () {
        // The user exited the Link flow.
    }
});
// Trigger the authentication view
$(document).on("click", '#plaidLinkButton', function () {
    linkHandler.open();
});

