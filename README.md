#[RxSwiftExmpleDemo](http://www.jianshu.com/p/63a03788f4cf)

##[Clone](https://github.com/KingComeFromChina/RxSwiftExmple.git)

`
git clone https://github.com/KingComeFromChina/RxSwiftExmple.git
`

##Pod

```
pod 'RxSwift',    '~> 3.0'
pod 'RxCocoa',    '~> 3.0'
```
##Use

```
import RxSwift
import RxCocoa
```

##Gif

![1](http://upload-images.jianshu.io/upload_images/3873966-e9e148d1ab65764c.gif?imageMogr2/auto-orient/strip)


##Total
###其实实现的功能很简单并且很常用，这个demo只是为了方便大家了解和学习RxSwift
##Demo
###1.Tap
#####一个简单的Demo，主要实现了点击按钮，数字加1，长按屏幕，数字加2
####核心代码如下：
```
 tapBtn.rx.tap.subscribe(onNext:{[weak self] in
        
            let number = Int((self?.numberLabel.text)!)
            
            self?.numberLabel.text = String(number! + 1)
        }).disposed(by: disposeBag)

        resetBtn.rx.tap.subscribe(onNext:{[weak self] in
        
            self?.numberLabel.text = "0"
        }).disposed(by: disposeBag)

  longPressGesture.rx.event.subscribe(onNext: { [weak self] _ in
        
            let number = Int((self?.numberLabel.text)!)
            
            self?.numberLabel.text = String(number! + 2)
            
        }).disposed(by: disposeBag)

```
###2.GetDateAndTime
#####获取当地日期和时间，实时更新
####核心代码如下：
```
 self.refreshBtn.rx.tap.map{ _ in
        
            let dateformatter = DateFormatter()
            
            dateformatter.dateStyle = .medium
            dateformatter.timeStyle = .medium
            
            return dateformatter.string(from: Date())
            
        }.bindTo(timeLabel.rx.text)
        .addDisposableTo(disposeBag)
```
###3.DismissKeyBoard
#####textView滑动时隐藏键盘，好像模拟器运行有点问题，待解决
####核心代码如下：
```
swipeGesture.rx.event.subscribe(onNext:{ [weak self] _ in
        

              self?.view.endEditing(true)
            
        }).addDisposableTo(disposeBag)

```
###4.AddPhoto
#####添加图片，用于平时开发中更换头像
####核心代码如下：
```
 
        barButtonItem.rx.tap.flatMapLatest({ [weak self] _ in
        
            return UIImagePickerController.rx.createWithParent(self) { picker in
            
                picker.sourceType    = .photoLibrary
                picker.allowsEditing = false
                }.flatMap({
                
                    $0.rx.didFinishPickingMediaWithInfo
                }).take(1)
        }).map({ info in
        
            return info[UIImagePickerControllerOriginalImage] as? UIImage
        }).bindTo(imageView.rx.image)
        .disposed(by: disposeBag)
        

```
###5.PullToRefresh
#####用Rx实现的下拉刷新，大家可以感受一下,同时也加入了删除和移动cell的功能
####核心代码如下：
```
 items.asObservable().bindTo(tableView.rx.items(cellIdentifier: cellID, cellType: UITableViewCell.self)) { (row, element , cell) in
        
            cell.textLabel?.text = element
        }.disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: {_ in
        
            items.value = items2
            
            self.refreshControl.endRefreshing()
        }).disposed(by: disposeBag)
```
###6.TableViewTest
#####模仿通讯录做的，同时也加入了索引
####核心代码如下：
```
dataSource.configureCell = { (_, TestTableView,indexPatch, element) in
            
            let cell = TestTableView.dequeueReusableCell(withIdentifier: self.cell)
            
            cell?.textLabel?.text = element
            
            return cell!
        }
        
        dataSource.sectionForSectionIndexTitle = {(dataSource, title , index) -> Int in
        
            return index
        }
        
        dataSource.sectionIndexTitles = {ds -> [String]? in
        
            return ds.sectionModels.map({ $0.model})
        }

```
###7.LocalDataTest
#####加载本地数据，模仿最近联系人的界面
####核心代码如下：
```
 dataSource.configureCell = {(_,tv,indexPath,element) in
        
            let cell = tv.dequeueReusableCell(withIdentifier: self.content)
            
            cell?.textLabel?.text = element["name"]
            
            let image = UIImage(named: element["avatar"]!)
            
            let imageSize = CGSize.init(width: 36, height: 36)
            
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
            
            let imageRect = CGRect.init(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
            
            image?.draw(in: imageRect)
            
            cell?.imageView?.layer.cornerRadius = 18
            
            cell?.imageView?.layer.masksToBounds = true
            
            cell?.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return cell!
        }

```