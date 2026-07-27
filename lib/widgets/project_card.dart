import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme/app_theme.dart';
import '../models/project_model.dart';
import 'status_badge.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;

  const ProjectCard({super.key, required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: project.imageUrls.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: project.imageUrls.first,
                      fit: BoxFit.cover,
                      placeholder: (c, u) => Container(color: Colors.grey.shade200),
                      errorWidget: (c, u, e) => Container(
                        color: AppColors.primaryGreen.withOpacity(0.08),
                        child: const Icon(Icons.image_not_supported_outlined, color: AppColors.primaryGreen),
                      ),
                    )
                  : Container(
                      color: AppColors.primaryGreen.withOpacity(0.08),
                      child: const Center(
                        child: Icon(Icons.apartment_rounded, color: AppColors.primaryGreen, size: 36),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          project.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      StatusBadge(status: project.status),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.category_outlined, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(project.sector, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      const SizedBox(width: 10),
                      Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(project.country, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearPercentIndicator(
                    lineHeight: 8,
                    percent: project.progressRatio,
                    barRadius: const Radius.circular(6),
                    backgroundColor: Colors.grey.shade200,
                    progressColor: AppColors.gold,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${project.amountRaised.toStringAsFixed(0)} / ${project.fundingGoal.toStringAsFixed(0)} ر.ع',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${project.sharesOfferedPercentage.toStringAsFixed(1)}% أسهم معروضة',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
