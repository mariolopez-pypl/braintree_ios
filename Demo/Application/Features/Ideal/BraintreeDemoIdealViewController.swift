import Foundation
import BraintreeLocalPayment
import BraintreeCore

class BraintreeDemoIdealViewController: BraintreeDemoPaymentButtonBaseViewController {

    var localPaymentClient: BTLocalPaymentClient!
    var paymentIDLabel: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        progressBlock("Loading iDEAL Merchant Account...")
        paymentButton.isHidden = false
        progressBlock("Ready!")
        title = "iDEAL"
    }

    override func createPaymentButton() -> UIView! {
        let iDEALButton = UIButton(type: .custom)
        iDEALButton.setTitle("Pay with iDEAL", for: .normal)
        iDEALButton.setTitleColor(.blue, for: .normal)
        iDEALButton.setTitleColor(.lightGray, for: .highlighted)
        iDEALButton.setTitleColor(.lightGray, for: .disabled)
        iDEALButton.addTarget(self, action: #selector(tappedIDEAL), for: .touchUpInside)
        iDEALButton.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        self.paymentIDLabel = label

        let stackView = UIStackView(arrangedSubviews: [iDEALButton, label])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iDEALButton.topAnchor.constraint(equalTo: stackView.topAnchor),
            iDEALButton.heightAnchor.constraint(equalToConstant: 19.5),

            label.topAnchor.constraint(equalTo: iDEALButton.bottomAnchor, constant: 5),
            label.heightAnchor.constraint(equalToConstant: 19.5)
        ])

        return stackView
    }

    @objc func tappedIDEAL() {
        paymentIDLabel.text = nil
        startPaymentWithBank()
    }

    private func startPaymentWithBank() {
        let apiClient = BTAPIClient(authorization: "sandbox_f252zhq7_hh4cpc39zq4rgjcg")!
        localPaymentClient = BTLocalPaymentClient(apiClient: apiClient)

        let request = BTLocalPaymentRequest()
        request.paymentType = "ideal"
        request.paymentTypeCountryCode = "NL"
        request.currencyCode = "EUR"
        request.amount = "1.01"
        request.givenName = "Linh"
        request.surname = "Ngo"
        request.phone = "639847934"
        request.email = "lingo-buyer@paypal.com"
        request.isShippingAddressRequired = false

        let postalAddress = BTPostalAddress()
        postalAddress.countryCodeAlpha2 = "NL"
        postalAddress.postalCode = "2585 GJ"
        postalAddress.streetAddress = "836486 of 22321 Park Lake"
        postalAddress.locality = "Den Haag"

        request.address = postalAddress
        request.localPaymentFlowDelegate = self

        localPaymentClient.startPaymentFlow(request) { result, error in
            guard let result else {
                if (error as? NSError)?.code == 5 {
                    self.progressBlock("Canceled 🎲")
                } else {
                    self.progressBlock("Error: \(error?.localizedDescription ?? "")")
                }
                return
            }

            let nonce = BTPaymentMethodNonce(nonce: result.nonce)
            self.completionBlock(nonce)
        }
    }
}

// MARK: - BTLocalPaymentRequestDelegate Conformance

extension BraintreeDemoIdealViewController: BTLocalPaymentRequestDelegate {

    func localPaymentStarted(
        _ request: BraintreeLocalPayment.BTLocalPaymentRequest,
        paymentID: String,
        start: @escaping () -> Void
    ) {
        paymentIDLabel.text = "LocalPayment ID: \(paymentID)"
        start()
    }
}
