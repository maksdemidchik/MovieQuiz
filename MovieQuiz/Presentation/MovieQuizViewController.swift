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
        showLoadingIndicator()
    }
    
    func showLoadingIndicator(){
        activityIndicator.isHidden=false
        activityIndicator.startAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alert = UIAlertController(
                    title: "Ошибка",
                    message: message,
                    preferredStyle: .alert)

                    let action = UIAlertAction(title: "Попробовать ещё раз",
                    style: .default) { [weak self] _ in
                        guard let self = self else { return }

                        self.presenter.restartGame()
        }

        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(quiz result: QuizResultsViewModel){
        let message = presenter.makeResultsMessage()
        let alert = UIAlertController(
                    title: result.title,
                    message: message,
                    preferredStyle: .alert)
                    let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                        guard let self = self else { return }

                        self.presenter.restartGame()
                    }

                alert.addAction(action)

                self.present(alert, animated: true, completion: nil)
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


