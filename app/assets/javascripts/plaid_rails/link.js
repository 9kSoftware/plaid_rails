function getPublicToken(access_token) {
    $.post('/plaid/create_token',
            {access_token: access_token},
            function (data, status, xhr) {
                return data.public_token;
            },
            'json'
            );
}
function getPlaid(plaidData) {
    var path = plaidData.data('plaid-rails-path');
    var access_token = plaidData.data('access-token');
    var env = plaidData.data('env');
    var product = plaidData.data('product');
    if (typeof product === 'undefined') {
        product = 'transactions';
    }
    var token;
    if (typeof access_token === 'undefined') {
        token = null;
    } else {
        token = getPublicToken(access_token);
    }

    var linkHandler = Plaid.create({
        env: env,
        apiVersion: 'v2',
        clientName: plaidData.data('client-name'),
        key: plaidData.data('key'),
        product: product,
        webhook: plaidData.data('webhook'),
        token: token,
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
                url: path,
                data: {
                    public_token: public_token,
                    access_token: plaidData.data('access-token'),
                    name: metadata.account.name,
                    type: metadata.account.type,
                    owner_type: plaidData.data('owner-type'),
                    owner_id: plaidData.data('owner-id'),
                    number: metadata.account.mask
                }
            });
        },
        onExit: function (err, metadata) {
            // The user exited the Link flow.
            if (err !== null) {
                // The user encountered a Plaid API error prior to exiting.
                $('#plaidError').append(err.error_message);                
            }
        }
    });
    return linkHandler;
}
// Trigger the authentication view
$(document).on("click", '#plaidLinkButton', function () {
    var plaidData = $(this);
    linkHandler = getPlaid(plaidData);
    var plaidType = plaidData.data('type');
    //open handler for the institution
    if (typeof plaidType === 'undefined') {
        linkHandler.open();
    } else {
        linkHandler.open(plaidType);
    }

});

