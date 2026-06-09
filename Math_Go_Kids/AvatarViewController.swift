//
//  AvatarViewController.swift
//  Math_Go_Kids
//
//  Created by Edwin Oswaldo Corona Perez on 15/06/26.
//

import UIKit
import AVFoundation

class AvatarViewController: UIViewController, UITextFieldDelegate {

    // MARK: - @IBOutlets
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet var avatarButtons: [UIButton]!
    
    // MARK: - Properties
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var nombreUsuario: String = ""
    private var avatarSeleccionado: UIButton?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupKeyboardObservers()
        nameTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playIntroVideo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let container = videoContainerView {
            playerLayer?.frame = container.bounds
        }
         avatarButtons?.forEach { boton in
            boton.layer.cornerRadius = boton.frame.height / 2
            boton.clipsToBounds = true
            
            boton.imageView?.contentMode = .scaleAspectFill
            
            if boton == avatarSeleccionado {
                boton.layer.borderWidth = 5
                boton.layer.borderColor = UIColor.systemMint.cgColor
                boton.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            } else {
                boton.layer.borderWidth = 0
                boton.backgroundColor = .clear
            }
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        videoContainerView.layer.cornerRadius = 20
        videoContainerView.clipsToBounds = true
        videoContainerView.backgroundColor = .black
        
        inputContainerView.layer.cornerRadius = 25
        inputContainerView.layer.shadowColor = UIColor.black.cgColor
        inputContainerView.layer.shadowRadius = 10
        inputContainerView.layer.shadowOpacity = 0.15
        inputContainerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        nameTextField.layer.cornerRadius = 15
        nameTextField.clipsToBounds = true
    }
    
    // MARK: - Video Logic
    private func playIntroVideo() {
        guard player == nil else { return }
        
        guard let path = Bundle.main.path(forResource: "introduccion", ofType: "mp4") else {
            print("⚠️ Error: No se encontró el archivo de video 'introduccion.mp4' en los recursos.")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        let playerInstance = AVPlayer(url: url)
        self.player = playerInstance
        
        let layer = AVPlayerLayer(player: playerInstance)
        layer.videoGravity = .resizeAspectFill
        layer.frame = videoContainerView.bounds
        self.playerLayer = layer
        
        videoContainerView.layer.addSublayer(layer)
        self.view.bringSubviewToFront(videoContainerView)
        
        playerInstance.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerInstance.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: .zero)
            self?.player?.play()
        }
    }
    
    // MARK: - @IBActions de Navegación
    @IBAction func atrasButtonTapped(_ sender: UIButton) {
        player?.pause()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - @IBActions de Interacción
    @IBAction func avatarButtonTapped(_ sender: UIButton) {
        self.avatarSeleccionado = sender
        
        self.view.setNeedsLayout()
        
        sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
        }, completion: nil)
    }
    
    @IBAction func jugarButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        
        guard let nombre = nameTextField.text, !nombre.isEmpty else {
            print("🚨 Por favor, escribe tu nombre antes de iniciar la aventura.")
            return
        }
        
        guard avatarSeleccionado != nil else {
            print("🚨 Elige un avatar de compañero antes de jugar.")
            return
        }
        
        self.nombreUsuario = nombre
        print("🎉 ¡Aventura iniciada para el jugador: \(self.nombreUsuario)!")
        
        player?.pause()
        
        self.performSegue(withIdentifier: "goToWorlds", sender: self)
    }
    
    // MARK: - Keyboard Handling (Mantiene el input visible)
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y -= (keyboardSize.height - 60)
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = 0
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Deinitialization
    deinit {
        player?.pause()
        NotificationCenter.default.removeObserver(self)
    }
}
