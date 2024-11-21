import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var QuestionTitleLabel: UILabel!
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var qustionsLabelText="Рейтинг этого фильма больше чем 6?"
    struct QuizQuestion {
        let image: String
        let text: String
        let corretAnswer: Bool
    }
    struct QuizStepViewModel {
      let image: UIImage
      let question: String
      let questionNumber: String
    }
    struct QuizResultsViewModel {
      let title: String
      let text: String
      let buttonText: String
    }
    private let questions: [QuizQuestion]=[QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: true),QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: true),QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: true),QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: true),QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: true),QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: true),QuizQuestion(image: "Old", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: false),QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: false),QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: false),QuizQuestion(image:"Vivarium", text: "Рейтинг этого фильма \nбольше чем 6?", corretAnswer: false)]
    override func viewDidLoad() {
        super.viewDidLoad()
        QuestionTitleLabel.font=UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font=UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font=UIFont(name: "YSDisplay-Medium", size: 20)
        indexLabel.font=UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font=UIFont(name: "YSDisplay-Bold", size: 23)
        show(quiz: convert(model: questions[0]))
        imageView.layer.cornerRadius=20
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let returnQuizStepViewModel=QuizStepViewModel(image:UIImage(named: model.image) ?? UIImage() , question: model.text, questionNumber: "\(currentQuestionIndex+1)/\(questions.count)")
        return returnQuizStepViewModel
    }
    private func show(quiz step: QuizStepViewModel) {
      imageView.image = step.image
      textLabel.text = step.question
      indexLabel.text = step.questionNumber
    }
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        let myanswer=true
        yesButton.isEnabled=false
        noButton.isEnabled=false
        showAnswerResult(isCorrect: myanswer==questions[currentQuestionIndex].corretAnswer)
    }
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        let myanswer=false
        yesButton.isEnabled=false
        noButton.isEnabled=false
        showAnswerResult(isCorrect: myanswer==questions[currentQuestionIndex].corretAnswer)
    }
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderColor=isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.borderWidth = 8
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius=20
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.noButton.isEnabled=true
            self.yesButton.isEnabled=true
        }
        if isCorrect {
            correctAnswers += 1
        }
    }
    private func showNextQuestionOrResults() {
        imageView.layer.borderColor=UIColor.ypBlack.cgColor
        imageView.layer.borderWidth = 8
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius=20
        if currentQuestionIndex == questions.count - 1 {
            let text="Ваш результат: \(correctAnswers)/10"
            let viewmodel=QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть ещё раз")
            showAlert(quiz: viewmodel)
            
        } else { // 2
            currentQuestionIndex += 1
            // идём в состояние "Вопрос показан"
            let nextQuestion = questions[currentQuestionIndex]
                    let viewModel = convert(model: nextQuestion)
                    
                    show(quiz: viewModel)
        }
    }
    private func showAlert(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
