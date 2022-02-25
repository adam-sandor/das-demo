const keycloak = new Keycloak({
    url: 'https://banking-demo.expo.styralab.com/auth',
    realm: 'banking-demo',
    clientId: 'banking-demo-portal'
});

function readyFn() {
    keycloak.onAuthError = function (errorData) {
        console.log("Auth Error: " + JSON.stringify(errorData) );
    };

    keycloak.init({
        enableLogging: true,
        onLoad: 'login-required'
    }).then(function(authenticated) {
        console.log(authenticated ? 'authenticated' : 'not authenticated');
        if (authenticated) {
            $.ajax({
                type: "GET",
                url: "/entitlements",
                headers: { "Authorization": "Bearer " + keycloak.token },
                success: entitlementsReady,
                error: entitlementsCallError
            });

            const logout = $("#logout");
            logout.show();
            logout.click(function() {
               keycloak.logout();
            });
        }
    }).catch(function() {
        console.log('failed to initialize');
    });
}

function entitlementsReady(data) {
    if (data.entitlements.includes('account/details')) {
        $("#account-details").show()
    }
    if (data.entitlements.includes('account/transactions')) {
        $("#account-transactions").show()
    }
    if (data.entitlements.includes('account/block')) {
        $("#account-block").show()
    }
    $('#user-full-name').text(data.subject.fullname);
    $('#user-role').text("Customer Support");
    $('#user-role-level').text("Level " + data.subject.role_level);
    $('#user-geo-region').text(data.subject.geo_region);
    if (data.subject.fullname === "Agent Brown") {
        $('#agent-pic').attr('src','img/agent-brown.png')
        $('#agent-pic').show()
    }
    if (data.subject.fullname === "Agent Smith") {
        $('#agent-pic').attr('src','img/agent-smith.png')
        $('#agent-pic').show()
    }
    if (data.subject.fullname === "Agent Jones") {
        $('#agent-pic').attr('src', 'img/agent-jones.png')
        $('#agent-pic').show()
    }
}

function entitlementsCallError(data) {
   $("#error").show();
   $("#error .error-text").text("Failed to load entitlements (" + data.statusText + " [" + data.status + "])");
}

$('#account-details').click(function () {
    const ready = function (data) {
        $("#error").hide();
        const htmlTable = `<table class="table table-bordered">
            <tbody>
            <tr>
                <td>IBAN:</td>
                <td>${data.iban}</td>
            </tr>
            <tr>
                <td>Account Holder:</td>
                <td>${data.accountHolder.name}</td>
            </tr>
            <tr>
                <td>Address: </td>
                <td>${data.accountHolder.address}</td>
            </tr>
            <tr>
                <td>Geographical Region:</td>
                <td>${data.geoRegion}</td>
            </tr>
            </tbody>
        </table>`;

        $('#data-table').html(htmlTable);
    };

    const error = function (data) {
        $("#error").show();
        $("#error .error-text").text("Failed to load account details (" + data.statusText + " [" + data.status + "])");
    }
    $.ajax({
        type: "GET",
        url: accountServiceUrl() + $('#account-iban-input').val() + "/details",
        headers: { "Authorization": "Bearer " + keycloak.token },
        success: ready,
        error: error
    })
});

$('#account-transactions').click(function () {
    const ready = function (data) {
        $("#error").hide();

        const tr = (t) => `<tr>
            <td>${t.otherAccountIban}</td>
            <td>${t.amount}</td>
            <td>${t.timeStamp}</td>
            <td>${t.type}</td>
            <td>${t.result}</td>
            </tr>`
        const htmlRows = data.transactionList.map(tr).join('')

        const htmlTable = `<table class="table table-bordered">
            <thead>
                <tr>
                  <th scope="col">Other Account</th>
                  <th scope="col">Amount</th>
                  <th scope="col">Time</th>
                  <th scope="col">Type</th>
                  <th scope="col">Result</th>
                </tr>
            </thead>
            <tbody>
                ${htmlRows}
            </tbody>
        </table>`;

        $('#data-table').html(htmlTable);
    };

    const error = function (data) {
        $("#error").show();
        $("#error .error-text").text("Failed to load account transactions (" + data.statusText + " [" + data.status + "])");
    }
    $.ajax({
        type: "GET",
        url: accountServiceUrl() + $('#account-iban-input').val() + "/transactions",
        headers: { "Authorization": "Bearer " + keycloak.token },
        success: ready,
        error: error
    })
});

function accountServiceUrl() {
    if (window.location.hash === '#account-controller-opa-disabled') {
        return '/account/'
    } else {
        return '/account/v2/'
    }
}

$(readyFn)

