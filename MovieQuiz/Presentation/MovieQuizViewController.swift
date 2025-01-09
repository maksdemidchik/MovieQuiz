import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol{
    
    
    // MARK: - Lifecycle
    private var presenter : MovieQuizPresenter!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var questionTitleLabel: UILabel!
    
    var alertPresenter: AlertPresenter = AlertPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTitleLabel.font=UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font=UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font=UIFont(name: "YSDisplay-Medium", size: 20)
        indexLabel.font=UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font=UIFont(name: "YSDisplay-Bold", size: 23)
        imageView.layer.masksToBounds = true
        presenter = MovieQuizPresenter(viewController: self)
        imageView.layer.cornerRadius=20
        let alertPresenter = AlertPresenter()
        alertPresenter.setViewController(self)
        self.alertPresenter = alertPresenter
        showLoadingIndicator()
    }
    
    func showLoadingIndicator(){
        activityIndicator.isHidden=false
        activityIndicator.startAnimating()
    }
    
    func showNetworkError(message: String) {
        activityIndicator.isHidden=true
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        
        alertPresenter.showAlert(quiz: model)
    }
    func show(quiz step: QuizStepViewModel) {
      imageView.image = step.image
      textLabel.text = step.question
      indexLabel.text = step.questionNumber
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool){
        imageView.layer.borderColor=isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.borderWidth = 8
        imageView.layer.masksToBounds = true
    }
    
    func yesNoModEnabled(bool:Bool)
    {
        yesButton.isEnabled=bool
        noButton.isEnabled=bool
    }
    
    func blackBorderColor(){
        imageView.layer.borderColor=UIColor.ypBlack.cgColor
    }
    
    func hideLoadingIndicator() {
            activityIndicator.isHidden = true
    }
}


