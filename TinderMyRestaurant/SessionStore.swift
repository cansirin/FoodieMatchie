//
//  SessionStore.swift
//  TinderMyRestaurant
//
//  Created by Can Sirin on 12/1/21.
//

import SwiftUI
import Firebase
import Combine

class SessionStore : ObservableObject {
	var didChange = PassthroughSubject<SessionStore, Never>()
	@Published var session: User? { didSet { self.didChange.send(self) }}
	var handle: AuthStateDidChangeListenerHandle?

	func listen () {
		// monitor authentication changes using firebase
		handle = Auth.auth().addStateDidChangeListener { (auth, user) in
			if let user = user {
				// if we have a user, create a new user model
				print("Got user: \(user)")
				self.session = User(
					uid: user.uid,
					displayName: user.displayName,
					email: user.email
				)
				print("session: \(self.session?.email) ------------ EMAIL")
			} else {
				// if we don't have a user, set our session to nil
				self.session = nil
			}
		}
	}

	func signUp(
		email: String,
		password: String,
		handler: @escaping AuthDataResultCallback
	) {
		Auth.auth().createUser(withEmail: email, password: password, completion: handler)
	}

	func signIn(
		email: String,
		password: String,
		handler: @escaping AuthDataResultCallback
	) {
		Auth.auth().signIn(withEmail: email, password: password, completion: handler)
	}

	func signOut () -> Bool {
		do {
			try Auth.auth().signOut()
			self.session = nil
			return true
		} catch {
			return false
		}
	}

	// additional methods (sign up, sign in) will go here
}

class User {
	var uid: String
	var email: String?
	var displayName: String?

	init(uid: String, displayName: String?, email: String?) {
		self.uid = uid
		self.email = email
		self.displayName = displayName
	}

}
