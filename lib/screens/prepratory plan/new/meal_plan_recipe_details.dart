import 'package:flutter/material.dart';
import 'package:gwc_customer/model/prepratory_meal_model/prep_meal_model.dart';
import 'package:sizer/sizer.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../model/program_model/meal_plan_details_model/child_meal_plan_details_model.dart';
import '../../../widgets/widgets.dart';

class MealPlanRecipeDetails extends StatefulWidget {
  final MealSlot? meal;
  final ChildMealPlanDetailsModel? mealPlanRecipe;
  final bool isFromProgram;
  const MealPlanRecipeDetails({
    Key? key,
    this.meal,
    this.mealPlanRecipe,
    this.isFromProgram = false,
  }) : super(key: key);

  @override
  State<MealPlanRecipeDetails> createState() => _MealPlanRecipeDetailsState();
}

class _MealPlanRecipeDetailsState extends State<MealPlanRecipeDetails>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
    meals = widget.meal;
    mealPlanRecipes = widget.mealPlanRecipe;

    print("itemImage");
    print(mealPlanRecipes?.itemImage);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  List colors = [
    newDashboardGreenButtonColor.withOpacity(0.3),
    kNumberCircleRed.withOpacity(0.3),
    kNumberCirclePurple.withOpacity(0.3),
  ];
  List ingredientColor = [
    NewStageLevels(
      newDashboardGreenButtonColor.withOpacity(0.3),
      "Savored Barley Mix",
      "30g",
    ),
    NewStageLevels(
      kNumberCircleRed.withOpacity(0.3),
      "Water",
      "as mentioned in variation",
    ),
    NewStageLevels(
      kNumberCirclePurple.withOpacity(0.3),
      "Salt ",
      "as per taste",
    ),
    // kNumberCircleAmber.withOpacity(0.3),
    // kNumberCircleGreen.withOpacity(0.3),
  ];

  MealSlot? meals;

  ChildMealPlanDetailsModel? mealPlanRecipes;

  @override
  Widget build(BuildContext context) {
    print("mealPlanRecipes : ${widget.mealPlanRecipe?.name}");
    return SafeArea(
      child: Scaffold(
        backgroundColor: gBackgroundColor,
        body: widget.isFromProgram
            ? Column(
                children: [
                  SizedBox(
                    height: 40.h,
                    width: double.maxFinite,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 33.h,
                            decoration: BoxDecoration(
                              image: (mealPlanRecipes?.itemImage != null && mealPlanRecipes?.itemImage != "")
                                  ? DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        mealPlanRecipes?.itemImage ?? '',
                                      ),
                                      fit: BoxFit.fill)
                                  : const DecorationImage(
                                      image: AssetImage(
                                        "assets/images/meal_placeholder.png",
                                      ),
                                      fit: BoxFit.fill),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0.h,
                                  left: 0.w,
                                  child: buildAppBar(
                                    () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                // Positioned(
                                //   right: 5.w,
                                //   bottom: 5.h,
                                //   child: GestureDetector(
                                //     onTap: () {},
                                //     child: Icon(
                                //       Icons.smart_display,
                                //       color: gWhiteColor,
                                //       size: 4.h,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 29.h,
                          left: 0,
                          right: 0,
                          child: Container(
                            width: double.maxFinite,
                            height: 8.h,
                            // padding:
                            //     EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: BoxDecoration(
                              color: gWhiteColor,
                              boxShadow: [
                                BoxShadow(
                                  color: kLineColor.withOpacity(0.5),
                                  offset: const Offset(2, 5),
                                  blurRadius: 5,
                                )
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  mealPlanRecipes?.name ?? '',
                                  style: TextStyle(
                                    color: gBlackColor,
                                    fontFamily: kFontBold,
                                    fontSize: 11.sp,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Cooking Time ",
                                      style: TextStyle(
                                        color: gHintTextColor,
                                        height: 1.3,
                                        fontFamily: kFontBook,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                    Icon(
                                      Icons.timer_outlined,
                                      color: gHintTextColor,
                                      size: 2.h,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      " - ${mealPlanRecipes?.cookingTime ?? ''}",
                                      style: TextStyle(
                                        color: gHintTextColor,
                                        height: 1.3,
                                        fontFamily: kFontBook,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ingredients",
                            style: TextStyle(
                              color: gBlackColor,
                              fontFamily: kFontBold,
                              fontSize: 11.sp,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          buildIngredients(mealPlanRecipes?.ingredient),
                          TabBar(
                              controller: _tabController,
                              labelColor: eUser().userFieldLabelColor,
                              unselectedLabelColor: eUser().userTextFieldColor,
                              // padding: EdgeInsets.symmetric(horizontal: 3.w),
                              isScrollable: true,
                              indicatorColor: gsecondaryColor,
                              labelStyle: TextStyle(
                                  fontFamily: kFontMedium,
                                  color: gPrimaryColor,
                                  fontSize: 12.sp),
                              unselectedLabelStyle: TextStyle(
                                  fontFamily: kFontBook,
                                  color: gHintTextColor,
                                  fontSize: 10.sp),
                              labelPadding: EdgeInsets.only(
                                  right: 10.w, left: 2.w, top: 1.h, bottom: 1.h),
                              indicatorPadding: EdgeInsets.only(right: 7.w),
                              tabs: const [
                                Text('How to make it'),
                                Text('Variations'),
                                Text('How to Store'),
                                Text('FAQ'),
                              ]),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                buildHowToMakeIt(
                                    "${mealPlanRecipes?.howToPrepare}"),
                                buildVariations(mealPlanRecipes?.variation),
                                buildHowToStore("${mealPlanRecipes?.howToStore}"),
                                buildFAQ(mealPlanRecipes?.faq),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  SizedBox(
                    height: 40.h,
                    width: double.maxFinite,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 33.h,
                            decoration: BoxDecoration(
                              image: (meals?.itemPhoto != null)
                                  ? DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        meals?.itemPhoto ?? '',
                                      ),
                                      fit: BoxFit.fill)
                                  : const DecorationImage(
                                      image: AssetImage(
                                        "assets/images/meal_placeholder.png",
                                      ),
                                      fit: BoxFit.fill),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0.h,
                                  left: 0.w,
                                  child: buildAppBar(
                                    () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                // Positioned(
                                //   right: 5.w,
                                //   bottom: 5.h,
                                //   child: GestureDetector(
                                //     onTap: () {},
                                //     child: Icon(
                                //       Icons.smart_display,
                                //       color: gWhiteColor,
                                //       size: 4.h,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 29.h,
                          left: 0,
                          right: 0,
                          child: Container(
                            width: double.maxFinite,
                            height: 8.h,
                            // padding:
                            //     EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: BoxDecoration(
                              color: gWhiteColor,
                              boxShadow: [
                                BoxShadow(
                                  color: kLineColor.withOpacity(0.5),
                                  offset: const Offset(2, 5),
                                  blurRadius: 5,
                                )
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  meals?.name ?? '',
                                  style: TextStyle(
                                    color: gBlackColor,
                                    fontFamily: kFontBold,
                                    fontSize: 11.sp,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Cooking Time ",
                                      style: TextStyle(
                                        color: gHintTextColor,
                                        height: 1.3,
                                        fontFamily: kFontBook,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                    Icon(
                                      Icons.timer_outlined,
                                      color: gHintTextColor,
                                      size: 2.h,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      " - ${meals?.cookingTime ?? ''}",
                                      style: TextStyle(
                                        color: gHintTextColor,
                                        height: 1.3,
                                        fontFamily: kFontBook,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ingredients",
                            style: TextStyle(
                              color: gBlackColor,
                              fontFamily: kFontBold,
                              fontSize: 11.sp,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          buildIngredients(meals?.ingredient),
                          TabBar(
                              controller: _tabController,
                              labelColor: eUser().userFieldLabelColor,
                              unselectedLabelColor: eUser().userTextFieldColor,
                              // padding: EdgeInsets.symmetric(horizontal: 3.w),
                              isScrollable: true,
                              indicatorColor: gsecondaryColor,
                              labelStyle: TextStyle(
                                  fontFamily: kFontMedium,
                                  color: gPrimaryColor,
                                  fontSize: 12.sp),
                              unselectedLabelStyle: TextStyle(
                                  fontFamily: kFontBook,
                                  color: gHintTextColor,
                                  fontSize: 10.sp),
                              labelPadding: EdgeInsets.only(
                                  right: 10.w, left: 2.w, top: 1.h, bottom: 1.h),
                              indicatorPadding: EdgeInsets.only(right: 7.w),
                              tabs: const [
                                Text('How to make it'),
                                Text('Variations'),
                                Text('How to Store'),
                                Text('FAQ'),
                              ]),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                buildHowToMakeIt("${meals?.howToPrepare}"),
                                buildVariations(meals?.variation),
                                buildHowToStore("${meals?.howToStore}"),
                                buildFAQ(meals?.faq),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  profileTile(String title, String subTitle, {bool isMultiline = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: title.isNotEmpty,
            child: Text(
              title,
              style: TextStyle(
                color: gBlackColor,
                fontFamily: kFontBold,
                fontSize: 11.sp,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          (!isMultiline)
              ? Text(
                  subTitle,
                  style: TextStyle(
                    color: gHintTextColor,
                    height: 1.3,
                    fontFamily: kFontBook,
                    fontSize: 10.sp,
                  ),
                )
              : Text(
                  subTitle.replaceAll('*', '\n'),
                  style: TextStyle(
                    color: gHintTextColor,
                    height: 1.3,
                    fontFamily: kFontBook,
                    fontSize: 10.sp,
                  ),
                ),
        ],
      ),
    );
  }

  buildIngredients(List<Ingredient>? ingredient) {
    return SizedBox(
      height: 14.h,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        // physics: const NeverScrollableScrollPhysics(),
        itemCount: ingredient?.length ?? 0,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
            child: Container(
              height: 10.h,
              width: 90,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                color: ((colors.toList()..shuffle()).first),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage(
                      'assets/images/empty_stomach.png',
                    ),
                    height: 5.h,
                  ),
                  SizedBox(height: 1.h),
                  Expanded(
                    child: Text(
                      ingredient?[index].ingredientName ?? '',
                      //   ingredientColor[index].title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: gBlackColor,
                        fontFamily: kFontBold,
                        fontSize: 9.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Flexible(
                    child: Text(
                      '${ingredient?[index].qty} ${ingredient?[index].unit}',
                      // ingredientColor[index].subTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: gHintTextColor,
                        height: 1,
                        fontFamily: kFontBook,
                        fontSize: 8.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  buildHowToMakeIt(String howToPrepare) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: kLineColor.withOpacity(0.3),
            width: double.maxFinite,
          ),
          SizedBox(height: 2.h),
          if (howToPrepare != null) profileTile("Instruction", howToPrepare),

          // profileTile("Instruction:",
          //     '1. In a pot, bring the water to a boil.\n2. Add barley mix and salt to the pot and stir to continue.\n3. Reduce the heat to low, cover the pot with a lid, and simmer for 5 to 10 minutes, or until the porridge is well cooked.\n4. Once cooked, remove the pot from the heat.\n5. Serve the barley porridge hot and enjoy!'),
          //
        ],
      ),
    );
  }

  buildVariations(List<Variation>? variation) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: kLineColor.withOpacity(0.3),
            width: double.maxFinite,
          ),
          SizedBox(height: 2.h),
          if (variation != null)
            ...variation
                .map(
                  (e) => profileTile(
                      e.variationTitle ?? '', e.variationDescription ?? ''),
                )
                .toList()
        ],
      ),
    );
  }

  buildHowToStore(String howToStore) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: kLineColor.withOpacity(0.3),
            width: double.maxFinite,
          ),
          SizedBox(height: 2.h),
          if (howToStore != null)
            if(!howToStore.contains("*"))  profileTile("", howToStore)
            else ...howToStore.split('*').map((e) {
              print(e);
              return profileTile(e.split(":").first, e.split(":").last);
            }).toList(),

          // profileTile("How to store and carry?",
          //     "1. Use a glass container: If you need to carry the porridge with you, consider using a glass container instead of plastic. Glass is non-toxic and won't leach any harmful chemicals into the food, which can potentially disrupt gut health."),
          //
        ],
      ),
    );
  }

  buildFAQ(List<Faq>? faq) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: kLineColor.withOpacity(0.3),
            width: double.maxFinite,
          ),
          SizedBox(height: 2.h),
          if (faq != null)
            ...faq
                .map(
                  (e) => profileTile(e.faqQuestion ?? '', e.faqAnswer ?? ''),
                )
                .toList()
        ],
      ),
    );
  }
}

class NewStageLevels {
  Color color;
  String title;
  String subTitle;

  NewStageLevels(this.color, this.title, this.subTitle);
}
