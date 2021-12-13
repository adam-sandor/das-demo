function readyFn() {
    $.ajax({
        type: "GET",
        url: "/entitlements",
        success: entitlementsReady,
        error: entitlementsCallError
    })
}

function entitlementsReady(data) {
    if (data.entitlements.includes('account/details')) {
        $("#account-details").show()
    }
    if (data.entitlements.includes('account/transactions')) {
        $("#account-transactions").show()
    }
    if (data.entitlements.includes('account/block')) {
        $("#account-modify").show()
    }
    $('#user-full-name').text(data.subject.fullname);
    $('#user-role').text(data.subject.role);
    $('#user-role-level').text("Level " + data.subject.role_level);
    $('#user-geo-region').text(data.subject.geo_region);
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
        url: "/account/" + $('#account-iban-input').val() + "/details",
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
        url: "/account/" + $('#account-iban-input').val() + "/transactions",
        success: ready,
        error: error
    })
});

$(readyFn)

