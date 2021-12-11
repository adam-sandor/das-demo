function readyFn() {
    $.ajax({
        type: "GET",
        url: "/entitlements",
        success: entitlementsReady,
        error: entitlementsCallError
    })
}

function entitlementsReady(data) {
    if (!data.entitlements.includes('account/details')) {
        $("#account-details").show()
    }
    if (!data.entitlements.includes('account/transactions')) {
        $("#account-transactions").show()
    }
    if (!data.entitlements.includes('account/modify')) {
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

$(readyFn)

