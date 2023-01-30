//
//  ContentView.swift
//  Stories-SwipeCard
//
//  Created by Seungchul Ha on 2023/01/30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
	
	@State var index = 0
	@State var stories = [
	
		Story(id: 0, image: "p0", offset: 0, title: "Jack the Perisian and the Black"),
		Story(id: 1, image: "p1", offset: 0, title: "The Dreaming Moon"),
		Story(id: 2, image: "p2", offset: 0, title: "Fallen In Love"),
		Story(id: 3, image: "p3", offset: 0, title: "Hounted Ground"),
		Story(id: 4, image: "p4", offset: 0, title: "God Is Good All The Time"),
 ]
	
	@State var scrolled = 0
	@State var index1 = 0
	
	var body: some View {
		ScrollView(.vertical, showsIndicators: false) {
			
			VStack {
				
				FirstPart()
				
				SecondPart()

				ThirdPart()

				CardPart()
				
				ForthPart()
				
				FifthPart()
				
				SixthPart()
			}
		}
		.background(
			LinearGradient(gradient: .init(colors: [Color("top"), Color("bottom")]), startPoint: .top, endPoint: .bottom)
				.edgesIgnoringSafeArea(.all)
		)
	}
	
	func calculateWidth() -> CGFloat {
		
		// horizontal padding 50
		
		let screen = UIScreen.main.bounds.width - 50
		
		// going to show first three cards
		// all other will be hidden...
		
		let width = screen - (2 * 30)
		
		return width
	}
	
	@ViewBuilder
	func FirstPart() -> some View {
		HStack {
			
			Button {
				
			} label: {
				Image(systemName: "line.3.horizontal")
			}
			
			Spacer()
			
			Button {
				
			} label: {
				Image(systemName: "magnifyingglass")
			}
		}
		.font(.system(size: 30))
		.foregroundColor(.black)
		.padding()
	}
	
	@ViewBuilder
	func SecondPart() -> some View {
		HStack {
			Text("Trending")
				.font(.system(size: 40, weight: .bold))

			Spacer(minLength: 0)

			Button {

			} label: {
				Image(systemName: "ellipsis")
//							.rotationEffect(.init(degrees: 90))
			}
		}
		.font(.system(size: 30))
		.foregroundColor(.black)
		.padding(.horizontal)
	}
	
	@ViewBuilder
	func ThirdPart() -> some View {
		HStack {
			
			Text("Animated")
				.font(.system(size: 15))
				.foregroundColor(index == 0 ? .white : Color("Color1").opacity(0.85))
				.fontWeight(.bold)
				.padding(.vertical, 6)
				.padding(.horizontal, 20)
				.background(Color("Color").opacity(index == 0 ? 1 : 0))
				.clipShape(Capsule())
				.onTapGesture {
					withAnimation(.easeInOut(duration: 0.5)) {
						index = 0
					}
				}
			
			Text("25+ Series")
				.font(.system(size: 15))
				.foregroundColor(index == 1 ? .white : Color("Color1").opacity(0.85))
				.fontWeight(.bold)
				.padding(.vertical, 6)
				.padding(.horizontal, 20)
				.background(Color("Color").opacity(index == 1 ? 1 : 0))
				.clipShape(Capsule())
				.onTapGesture {
					withAnimation(.spring(response: 0.5, dampingFraction: 1.5, blendDuration: 3)) {
						index = 1
					}
				}
			
			Spacer()
		}
		.padding(.horizontal)
	}
	
	@ViewBuilder
	func CardPart() -> some View {
		// Card View...
		ZStack {

			// ZStack Will Overlap Views So Last Will Become First...

			ForEach(stories.reversed()) { story in

				HStack {

					ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {

						Image(story.image)
							.resizable()
							.aspectRatio(contentMode: .fill)
							// Dynamic Frame...
							// Dynamic Height....
							.frame(width: calculateWidth(), height: (UIScreen.main.bounds.height / 1.8) - CGFloat(story.id - scrolled) * 50)
							.cornerRadius(15)

						CardInnerPart(story: story)

					}
					.offset(x: story.id - scrolled <= 2 ? CGFloat(story.id - scrolled) * 30 : 60)

					Spacer(minLength: 0)
				}
				.contentShape(Rectangle())
				// Adding Gesture...
				.offset(x: story.offset)
				.gesture(DragGesture().onChanged({ (value) in

					withAnimation {

						// Disabling Drag For Last Card...
						if value.translation.width < 0 && story.id != stories.last!.id {

							stories[story.id].offset = value.translation.width
						} else {

							// restoring cards...
							if story.id > 0 {
								stories[story.id - 1].offset = -(calculateWidth() + 60) + value.translation.width
							}
						}

					}

				}).onEnded({ (value) in

					withAnimation {

						if value.translation.width < 0 {

							if -value.translation.width > 180 && story.id != stories.last!.id {

								// Moving View Away...

								stories[story.id].offset = -(calculateWidth() + 60)

								scrolled += 1

							} else {

								stories[story.id].offset = 0
							}

						} else {

							// Restoring Card
							if story.id > 0 {

								if value.translation.width > 180 {

									stories[story.id - 1].offset = 0
									scrolled -= 1
								} else {

									stories[story.id - 1].offset = -(calculateWidth() + 60)
								}
							}
						}

					}

				}))

			}
		}
		// Max Height...
		.frame(height: UIScreen.main.bounds.height / 1.8)
		.padding(.horizontal, 25)
		.padding(.top, 25)
	}
	
	@ViewBuilder
	func CardInnerPart(story: Story) -> some View {
		VStack(alignment: .leading, spacing: 18) {

			HStack {

				Text(story.title)
					.font(.title)
					.fontWeight(.bold)
					.foregroundColor(.white)

				Spacer()
			}

			Button {

			} label: {

				Text("Read Later")
					.font(.caption)
					.fontWeight(.bold)
					.foregroundColor(.white)
					.padding(.vertical, 6)
					.padding(.horizontal, 25)
					.background(Color("Color1"))
					.clipShape(Capsule())
			}

		}
		.frame(width: calculateWidth() - 40)
		.padding(.leading, 20)
		.padding(.bottom, 20)
	}

	@ViewBuilder
	func ForthPart() -> some View {
		HStack {
			Text("Favourites")
				.font(.system(size: 40, weight: .bold))

			Spacer(minLength: 0)

			Button {

			} label: {
				Image(systemName: "ellipsis")
//							.rotationEffect(.init(degrees: 90))
			}
		}
		.font(.system(size: 30))
		.foregroundColor(.black)
		.padding(.horizontal)
		.padding(.top, 25)
	}
	
	@ViewBuilder
	func FifthPart() -> some View {
		HStack {
			
			Text("Latest")
				.font(.system(size: 15))
				.foregroundColor(index1 == 0 ? .white : Color("Color1").opacity(0.85))
				.fontWeight(.bold)
				.padding(.vertical, 6)
				.padding(.horizontal, 20)
				.background(Color("Color1").opacity(index1 == 0 ? 1 : 0))
				.clipShape(Capsule())
				.onTapGesture {
					withAnimation(.easeInOut(duration: 0.5)) {
						index1 = 0
					}
				}
			
			Text("9+ Stories")
				.font(.system(size: 15))
				.foregroundColor(index1 == 1 ? .white : Color("Color1").opacity(0.85))
				.fontWeight(.bold)
				.padding(.vertical, 6)
				.padding(.horizontal, 20)
				.background(Color("Color1").opacity(index1 == 1 ? 1 : 0))
				.clipShape(Capsule())
				.onTapGesture {
					withAnimation(.spring(response: 0.5, dampingFraction: 1.5, blendDuration: 3)) {
						index1 = 1
					}
				}
			
			Spacer()
		}
		.padding(.horizontal)
	}
	
	@ViewBuilder
	func SixthPart() -> some View {
		
		HStack {
			
			Image("p1")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(width: UIScreen.main.bounds.width - 80, height: 250)
				.cornerRadius(15)
			
			Spacer(minLength: 0)
		}
		.padding(.horizontal)
		.padding(.top, 20)
		.padding(.bottom)
	}
}

// ellipsis
// line.3.horizontal
// magnifyingglass


// Sample Data...
struct Story: Identifiable {
	
	var id: Int
	var image: String
	var offset: CGFloat
	var title: String
}


