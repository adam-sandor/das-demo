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
    
}

function entitlementsCallError(data) {
   $("#error").show();
   $("#error .error-text").text("Failed to load entitlements (" + data.statusText + " [" + data.status + "])");
}

$(readyFn)

