//
//  ContentView.swift
//  PSS WatchKit Extension
//
//  Created by Adamsun0306 on 2022/3/24.
//

import SwiftUI

struct ContentView: View {
    
    class GameState{
        class GameRun{
            var now:Int
            var game:Int
            
            func reset(){
                self.now=1
                self.game=0
            }
            
            func play(r:Int) -> Bool{
                self.game+=1
                if(r==0 && self.now<6){
                    self.now+=1
                }else if(r==2 && self.now>1){
                    self.now-=1
                }
                
                if((self.game-self.now>2 && self.game>5)||self.game-self.now>3) {return true}
                return false
            }
            
            init(){
                self.now=1
                self.game=1
            }
        }
        
        var k:[Int]
        var total:Int
        var recommend:Int
        var currentEnemy:Int
        var icon:[String]=["🖐", "✌️", "✊","Whatever"]
        var initializing:Bool=true
        
        var gr=GameRun()
        
        init(){
            self.k=[3,3,3]
            self.total = 9
            self.currentEnemy = 0
            self.recommend=2
        }
        
        func reset(b:inout [String]){
            self.gr.reset()
            self.k=[3,3,3]
            self.total = 9
            self.initializing=true
            b=self.icon
            b[3]="Choose your first"
        }
        
        func race(player:Int,enemy:Int) -> Int{
            var ans:Int=((3+player-enemy)%3+1)%3-1
            ans*=2
            if(ans==2) {ans=3}
            return ans
        }
        
        func game(result:Int, b:inout [String]){
            if(self.total==0){
                self.reset(b: &b)
                return
            }
            if(self.initializing){
                self.initializing=false
                self.recommend=result
                b=["Win","Draw","Lose",self.icon[self.recommend]]
                for i in 0...2{
                    b[i]=String(k[(recommend+i+2)%3])+icon[(recommend+i+2)%3]+b[i]
                }
                b[3]+=" ("+String(10-self.total)+"/9)"
                return
            }
            if(recommend==3){
                self.recommend=result
                b=["Win","Draw","Lose",self.icon[self.recommend]]
                for i in 0...2{
                    b[i]=String(k[(recommend+i+2)%3])+icon[(recommend+i+2)%3]+b[i]
                }
                b[3]+=" ("+String(10-self.total)+"/9)"
                return
            }
            let enemy:Int
            var probability:[Float]
            enemy=(self.recommend + 2 + result)%3
            if(k[enemy]==0){
                return
            }
            self.k[enemy]-=1
            self.total-=1
            probability=[0,0,0]
            for i in 0...2 {
                for j in 0...2{
                    probability[i]=probability[i] + (Float(race(player: i,enemy: j))*Float(k[j])/Float(total))
                }
            }
            recommend = probability[0]>probability[1] ? (probability[0]>probability[2] ? 0 : 2) : (probability[1]>probability[2] ? 1 : 2)
            b=["Win","Draw","Lose",icon[recommend]]
            for i in 0...2{
                b[i]=String(k[(recommend+i+2)%3])+icon[(recommend+i+2)%3]+b[i]
            }
            if(k[0]==k[1] && k[0]==k[2]){
                recommend=3
                b=icon
                for i in 0...2{
                    b[i]=String(k[i])+b[i]+"Your"
                }
            }
            if(self.gr.play(r: result)){b[3]="Give Up!"+b[3]}
            if(total>0){
                b[3]+=" ("+String(10-self.total)+"/9)"
            }else{
                b=["Reset","Reset","Reset","Finish!"]
            }
        }
    }
    
    var gc=GameState()
    
    @State var buttons:[String]=["🖐", "✌️", "✊","Choose"] //"📄", "✂️", "🪨",
    
    var body: some View {
        ScrollView{
            VStack{
                Text(buttons[3])
                Button(action: {
                    gc.game(result: 0,b: &buttons)
                }, label: {
                    Text(buttons[0])
                })
                Button(action: {
                    gc.game(result: 1,b: &buttons)
                }, label: {
                    Text(buttons[1])
                })
                Button(action: {
                    gc.game(result: 2,b: &buttons)
                }, label: {
                    Text(buttons[2])
                })
                Button(action: {
                    gc.reset(b: &buttons)
                }, label: {
                    Text("Reset")
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
