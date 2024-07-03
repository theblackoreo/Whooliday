//
//  SwiftUIView.swift
//  Whooliday
//
//  Created by Tommaso Diegoli on 19/06/24.
//
import SwiftUI

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @EnvironmentObject var authModel: AuthModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var selectedCountry: Country? = Country(name: "Italy", alpha2Code: "IT")
    @State private var selectedCurrency: Currency? = Currency(name: "Euro", code: "EUR")
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundGradient
                
                VStack(spacing: 25) {
                    logoView
                    welcomeText
                    inputFields
                    pickers
                    signupButton
                }
                .padding(.horizontal, 30)
                .frame(minHeight: geometry.size.height)
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(gradient: Gradient(colors: [Color.orange.opacity(1), Color.red.opacity(1)]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
    
    private var logoView: some View {
        Image("logosmall")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .foregroundColor(.white)
    }
    
    private var welcomeText: some View {
        Text("Join the adventure!")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
    }
    
    private var inputFields: some View {
        VStack(spacing: 20) {
            CustomTextField(text: $name, placeholder: "Name", icon: "person")
            CustomTextField(text: $email, placeholder: "Email", icon: "envelope")
            CustomTextField(text: $password, placeholder: "Password", icon: "lock", isSecure: true)
        }
    }
    
    private var pickers: some View {
        VStack(spacing: 20) {
            // Country picker
                     Picker("Country", selection: $selectedCountry) {
                         ForEach(Country.allCountries, id: \.self) { country in
                             Text(country.name).tag(country as Country?)
                         }
                     }
                     .pickerStyle(MenuPickerStyle())
                     .padding()
                     .background(Color.gray.opacity(0.2))
                     .cornerRadius(5.0)
                     
                     // Currency picker
                     Picker("Currency", selection: $selectedCurrency) {
                         ForEach(Currency.allCurrencies, id: \.self) { currency in
                             Text("\(currency.code) - \(currency.name)").tag(currency as Currency?)
                         }
                     }
                     .pickerStyle(MenuPickerStyle())
                     .padding()
                     .background(Color.gray.opacity(0.2))
                     .cornerRadius(5.0)
        }
    }
    
    private var signupButton: some View {
        Button(action: signup) {
            Text("Sign Up")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .foregroundColor(.red)
                .fontWeight(.bold)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
    
    private func signup() {
        Task {
            if name.isEmpty {
                alertMessage = "Name cannot be empty, please try again"
                showAlert = true
                return
            }
            
            do {
                try await authModel.signUp(withEmail: email, password: password, name: name, country: selectedCountry, currency: selectedCurrency)
            } catch {
                handleSignUpError(error)
            }
        }
    }
    
    private func handleSignUpError(_ error: Error) {
        switch (error as NSError).code {
        case 17026:
            alertMessage = "The password must be 6 characters long or more, please try again"
        case 17034:
            alertMessage = "An email address must be provided, please try again"
        case 17008:
            alertMessage = "The email is not in the correct format, please try again"
        case 17004, 17007:
            alertMessage = "There is already another user with this email, please try again"
        default:
            alertMessage = "Something went wrong, please try again"
        }
        showAlert = true
        password = ""
    }
}

struct CustomPicker<T: Hashable & Identifiable>: View {
    @Binding var selection: T?
    let placeholder: String
    let options: [T]
    
    var body: some View {
        Picker(placeholder, selection: $selection) {
            ForEach(options) { option in
                Text(String(describing: option)).tag(option as T?)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .padding()
        .background(Color.white.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
        .accentColor(.white)
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView().environmentObject(AuthModel())
    }
}
