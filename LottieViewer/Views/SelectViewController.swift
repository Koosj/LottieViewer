//
//  SelectViewController.swift
//  LottieViewer
//
//  Created by Bonsung Koo on 2021/05/06.
//

import UIKit
import RxSwift
import UniformTypeIdentifiers

final class SelectViewController: BaseViewController, UIDocumentPickerDelegate {
    
    @IBOutlet weak var selectBarItem: UIBarButtonItem!
    @IBOutlet weak var infomationBarItem: UIBarButtonItem!
    
    private let _disposeBag: DisposeBag = DisposeBag()
    var coordinator: SelectCoordinator?
    var selectedAnimationViewModel: SelectedAnimationViewModel!
    
    static func instantiate(viewModel: SelectedAnimationViewModel) -> SelectViewController? {
        
        let storyBoard = UIStoryboard.init(name: StoryBoard.Main.rawValue, bundle: .main)
        
        guard let selectViewController = storyBoard.instantiateViewController(identifier: SelectViewController.className) as? SelectViewController else { return nil }
        
        selectViewController.selectedAnimationViewModel = viewModel
        
        return selectViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        _configurePlayViewController()
        _bind()
    }
    
    private func _configurePlayViewController() {
        guard let playViewController = PlayViewController.instantiate(viewModel: selectedAnimationViewModel) else { return }
        
        addChild(playViewController)
        view.addSubview(playViewController.view)
    }
    
    private func _bind() {
        selectedAnimationViewModel.output
            .animation
            .asObservable()
            .map({ $0?.animationName ?? "Lottie Player" })
            .bind(to: navigationItem.rx.title)
            .disposed(by: _disposeBag)
        
        selectBarItem.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                
                let documentTypes = UTType.types(tag: "json", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
                let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: documentTypes)
                
                documentPicker.delegate = self
                
                self?.present(documentPicker, animated: true, completion: nil)
                
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: _disposeBag)
        
        infomationBarItem.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                
                guard let infomationViewController = InfomationViewController.instantiate(viewModel: InfomationViewModel()) else { return }
                self?.present(infomationViewController, animated: true, completion: nil)
                
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: _disposeBag)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileUrl = urls.first else { return }
        
        let isAccess = fileUrl.startAccessingSecurityScopedResource()
        
        if isAccess {
            let animationModel = AnimationModel(animationName: fileUrl.lastPathComponent.replacingOccurrences(of: ".json", with: ""), animationFilePath: fileUrl.path)
            selectedAnimationViewModel.input.animation.accept(animationModel)
            
            fileUrl.stopAccessingSecurityScopedResource()
        }
    }
}
