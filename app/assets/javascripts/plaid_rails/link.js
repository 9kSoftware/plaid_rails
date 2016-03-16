function getPlaid(plaidData) {
    var url = null;
    var token = plaidData.data('token');
    var env = plaidData.data('env');
    if (typeof token === 'undefined') {
        url = '/plaid/authenticate';
        token = null;
    } else {
        url = '/plaid/update';
    }
    // set token for test environment
    if (env === 'tartan' && typeof plaidData.data('type') !== 'undefined') {
        token = 'test,' + plaidData.data('type') + ',connected'
    }

    var linkHandler = Plaid.create({
        env: env,
        clientName: plaidData.data('client-name'),
        key: plaidData.data('key'),
        product: 'connect',
        webhook: plaidData.data('webhook'),
        longtail: plaidData.data('longtail'),
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
                url: url,
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
    return linkHandler;
}
// Trigger the authentication view
$(document).on("click", '#plaidLinkButton', function () {
    var plaidData = $(this);
    linkHandler = getPlaid(plaidData);
    var plaidType = plaidData.data('type')
    //open handler for the institution
    if (typeof plaidType === 'undefined') {
        linkHandler.open();
    } else {
        linkHandler.open(plaidType);
    }

});

