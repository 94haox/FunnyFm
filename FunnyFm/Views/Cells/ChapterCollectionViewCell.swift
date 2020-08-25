//
//  ChapterCollectionViewCell.swift
//  FunnyFm
//
//  Created by wt on 2020/3/19.
//  Copyright © 2020 Duke. All rights reserved.
//

import UIKit

class ChapterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var durationLB: UILabel!
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var chapterIndexLB: UILabel!
    var skipClourse: ((CMTime)->Void)?
    var chapter: Chapter?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cornerRadius = 12.auto()
        self.titleLB.numberOfLines = 2
        self.chapterIndexLB.font = m_mfont(16)
    }
    
    func config(chapter: Chapter, index: Int) {
        self.chapter = chapter
        self.titleLB.text = chapter.title
        self.chapterIndexLB.text = "\(index)"
        self.timeLB.text = Date.formatIntervalToMM(NSInteger(chapter.time.seconds))
        self.durationLB.text = Date.formatIntervalToString(NSInteger(chapter.time.seconds))
    }

    @IBAction func skipAction(_ sender: Any) {
        if self.skipClourse.isSome {
            self.skipClourse!(self.chapter!.time)
        }
    }
}
