import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Lifecycle

    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var questionTitleLabel: UILabel!
    private var currentQuestionIndex = 0
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var questionfactory: QuestionFactoryProtocol = QuestionFactory()
    private var alertPresenter: AlertPresenter = AlertPresenter()
    private var statisticService: StatisticServiceProtocol = StatisticService()
    private var correctAnswer = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTitleLabel.font=UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font=UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font=UIFont(name: "YSDisplay-Medium", size: 20)
        indexLabel.font=UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font=UIFont(name: "YSDisplay-Bold", size: 23)
        let questionfactory = QuestionFactory()
        questionfactory.setup(delegate: self)
        self.questionfactory = questionfactory
        imageView.layer.cornerRadius=20
        let alertPresenter = AlertPresenter()
        alertPresenter.setViewController(self)
        self.alertPresenter = alertPresenter
        questionfactory.requestNextQuestion()
        let statisticService = StatisticService()
        self.statisticService = statisticService
        
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let returnQuizStepViewModel=QuizStepViewModel(image:UIImage(named: model.image) ?? UIImage() , question: model.text, questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)")
        return returnQuizStepViewModel
    }
    private func show(quiz step: QuizStepViewModel) {
      imageView.image = step.image
      textLabel.text = step.question
      indexLabel.text = step.questionNumber
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
         yesNoButtonAction(bool: true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        yesNoButtonAction(bool: false)
    }
    private func yesNoButtonAction(bool: Bool) {
        let myanswer=bool
        yesButton.isEnabled=false
        noButton.isEnabled=false
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: myanswer==currentQuestion.corretAnswer)
    }
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderColor=isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.borderWidth = 8
        imageView.layer.masksToBounds = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.showNextQuestionOrResults()
            self.noButton.isEnabled=true
            self.yesButton.isEnabled=true
        }
        if isCorrect {
            correctAnswer += 1
        }
    }
    private func showNextQuestionOrResults() {
        imageView.layer.borderColor=UIColor.ypBlack.cgColor
        imageView.layer.borderWidth = 8
        imageView.layer.masksToBounds = true
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswer, total: questionsAmount)
            let text="Ваш результат: \(correctAnswer)/10\nКоличество сыгранных квизов:  \(statisticService.gamesCount)\nРекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))\nСредняя точность: "+"\(String(format: "%.2f", statisticService.totalAccuracy))%"
            let alertModel=AlertModel(title: "Этот раунд окончен!", message: text, buttonText:  "Сыграть ещё раз",completion:actionAlert)
            alertPresenter.showAlert(quiz: alertModel)

            
        } else { // 2
            currentQuestionIndex += 1
            // идём в состояние "Вопрос показан"
            self.questionfactory.requestNextQuestion()
        }
    }
    private func actionAlert(){
        self.currentQuestionIndex = 0
        self.correctAnswer = 0
        questionfactory.requestNextQuestion()
    }
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
                return
            }

            currentQuestion = question
            let viewModel = convert(model: question)
            
            DispatchQueue.main.async { [weak self] in
                self?.show(quiz: viewModel)
            }
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
