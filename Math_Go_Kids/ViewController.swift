//
//  ViewController.swift
//  Math_Go_Kids
//
//  Created by Edwin Oswaldo Corona Perez on 04/06/26.
//
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var timer: Timer?
    var currentProgress: Float = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProgressViewStyle()
        startLoadingSimulation()
    }
    
    private func setupProgressViewStyle() {
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 6.0)
        
        progressView.layer.cornerRadius = progressView.frame.height / 2
        progressView.clipsToBounds = true
        
         progressView.layer.shadowColor = UIColor.systemGreen.cgColor
        progressView.layer.shadowRadius = 15.0
        progressView.layer.shadowOpacity = 0.85
        progressView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        progressView.layer.masksToBounds = false
    }
    
    private func startLoadingSimulation() {
        updateLoadingUI(progress: currentProgress)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            self.currentProgress += 0.005
            self.progressView.setProgress(self.currentProgress, animated: true)
            self.updateLoadingUI(progress: self.currentProgress)
            
            if self.currentProgress >= 1.0 {
                timer.invalidate()
                self.navigateToNextScreen()
            }
        }
    }
    
    private func updateLoadingUI(progress: Float) {
        let percentage = Int(min(progress, 1.0) * 100)
        percentLabel?.text = "Cargando... \(percentage)%"
        
        if percentage >= 90 {
            statusLabel?.text = "¡Todo listo para la aventura!"
        } else if percentage >= 50 {
            statusLabel?.text = "¡Conectando a nuestro universo mágico!"
        } else if percentage >= 15 {
            statusLabel?.text = "¡Iniciando el viaje!"
        } else {
            statusLabel?.text = "¡Prendiendo motores!" 
        }
    }
    
    private func navigateToNextScreen() {
        print("¡Carga completa! Transición a la pantalla de Perfil.")
        // Aquí dispararás el cambio de pantalla. Por ejemplo, usando Segues:
    }
}

