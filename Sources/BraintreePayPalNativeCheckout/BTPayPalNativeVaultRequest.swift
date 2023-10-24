import Foundation

#if canImport(BraintreeCore)
import BraintreeCore
#endif

#if canImport(BraintreePayPal)
import BraintreePayPal
#endif

/// Options for the PayPal Vault flow.
@objcMembers public class BTPayPalNativeVaultRequest: BTPayPalVaultRequest {

    // MARK: - Initializer

    /// Initializes a PayPal Native Vault request
    /// - Parameters:
    ///   - offerCredit: Optional: Offers PayPal Credit if the customer qualifies. Defaults to `false`.
    ///   - userAuthenticationEmail: User email to initiate a quicker authentication flow in cases where the user has a PayPal Account with the same email.
    ///   - billingAgreementDescription: Optional: Display a custom description to the user for a billing agreement. For Checkout with Vault flows, you must also set
    ///   `requestBillingAgreement` to `true` on your `BTPayPalCheckoutRequest`.
    public init(
        offerCredit: Bool = false,
        userAuthenticationEmail: String? = nil,
        billingAgreementDescription: String? = nil
    ) {
        super.init(offerCredit: offerCredit, userAuthenticationEmail: userAuthenticationEmail)
        self.billingAgreementDescription = billingAgreementDescription
    }
}
