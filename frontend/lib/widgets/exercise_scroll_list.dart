import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/viewmodels_lib.dart';
import 'package:frontend/views/exercise_view.dart';
import 'package:provider/provider.dart';

class ExerciseListTile extends StatelessWidget {
  const ExerciseListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final exercise = context.watch<ExerciseViewModel>();
    final userInfo = context.watch<UserInfoViewModel>();

    return ListTile(
      leading: Image(
        image: AssetImage(
          '${exercise.assetsFolder}/${exercise.exerciseName.toLowerCase().replaceAll(" ", "_")}_thumbnail.png',
        ),
        width: 100,
        height: 100,
      ),
      minTileHeight: 100,
      title: Center(
        child: Column(
          children: [
            Text(
              exercise.exerciseName,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              exercise.muscleRegions.join(', '),
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
      trailing: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          exercise.isFavorite
              ? userInfo.favoriteExercises.removeExercise(exercise)
              : userInfo.favoriteExercises.addExercise(exercise);
          exercise.toggleFavorite();
        },
        child: Icon(
          exercise.isFavorite ? Icons.favorite : Icons.favorite_border,
          size: 40,
        ),
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => ExerciseView(exercise: exercise),
          ),
        );
      },
    );
  }
}

class ExerciseScrollList extends StatelessWidget {
  final ExerciseListViewModel exercises;
  final UserInfoViewModel userInfo;

  const ExerciseScrollList({
    super.key,
    required this.exercises,
    required this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    if (exercises.exerciseList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SliverList(
      delegate: SliverChildListDelegate(
        exercises.exerciseList.map((exercise) {
          return ChangeNotifierProvider<ExerciseViewModel>(
            create: (_) => exercise,
            child: ChangeNotifierProvider<UserInfoViewModel>(
              create: (_) => userInfo,
              child: const ExerciseListTile(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
