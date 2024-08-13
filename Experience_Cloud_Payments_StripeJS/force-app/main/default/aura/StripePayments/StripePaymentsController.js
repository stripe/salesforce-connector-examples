({
    scriptLoaded: function(component, event, helper) {
        //getPublishablekey
        //// Fetch Publishable Key from server
        	console.log("publishablekey get: ");
            var action = component.get("c.getPublishablekey");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var publishablekey = response.getReturnValue();
                    component.set("v.publishablekey", publishablekey);
                } else {
                    console.error("Failed to fetch publishable key:", response.getError());
                }
             });
        console.log("publishablekey: ", component.get("v.publishablekey"));
        var stripe = Stripe('pk_test_51Pn1F8HhfSbld7PNO39xtPxyXFDDT4zbIbXVIxPTzUkVrKxYcYLIe51u1nm7oAIOTJyDSyHtk5mhSmEsHJyzqmFL00FL8mQ6hN');
        component.set("v.stripe", stripe);
        var redirectStatus = new URLSearchParams(window.location.search).get("redirect_status");
        component.set("v.showPaymentElement", !redirectStatus);
        if (!redirectStatus) {
            // Fetch clientSecret from server
            var action = component.get("c.paymentIntent");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var clientSecret = response.getReturnValue();
                    component.set("v.clientSecret", clientSecret);
                    // Check if Stripe is loaded before initializing
                    helper.initializeStripe(component, clientSecret);
                } else {
                    console.error("Failed to fetch client secret:", response.getError());
                }
            });
            $A.enqueueAction(action);
        } else {
            helper.checkStatus(component);
        }

    },

    handleSubmit: function(component, event, helper) {
    event.preventDefault();
    console.log("handleSubmit triggered"); // Check if this logs in the console
    helper.submitPayment(component);
}
})