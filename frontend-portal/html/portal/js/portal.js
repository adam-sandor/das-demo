function readyFn() {
    $.ajax({
        type: "GET",
        beforeSend: function (request) {
            request.setRequestHeader("Authorization", "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjEzMDA4MTkzODAsImlzcyI6Imp3dC5pbyIsInJvbGUiOiJjdXN0b21lcl9zdXBwb3J0Iiwic3ViIjoiSmFuZSBEb2UiLCJ1c2VySWQiOiIxMjM0Iiwicm9sZV9sZXZlbCI6IjIifQ.TLb16PIk9TwUySf8ieGd5OGlehBkvUVX_XDCOOpd_zY");
        },
        url: "/entitlements",
        success: entitlementsReady
    })
}

function entitlementsReady(data) {
    if (!data.includes('account/status')) {
        $("#account-status").remove()
    }
    if (!data.includes('account/transactions')) {
        $("#account-transactions").remove()
    }
    if (!data.includes('account/modify')) {
        $("#account-modify").remove()
    }
}

$(readyFn)

