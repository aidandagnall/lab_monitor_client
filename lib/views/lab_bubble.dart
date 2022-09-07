import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_availability_checker/models/lab.dart';
import 'package:lab_availability_checker/providers/enable_tooltip_provider.dart';
import 'package:lab_availability_checker/providers/module_code_provider.dart';
import 'package:provider/provider.dart';

class LabBubble extends StatelessWidget {
  const LabBubble({Key? key, required this.lab}) : super(key: key);
  final Lab? lab;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: Consumer<EnableTooltipProvider>(
            builder: (ctx, provider, child) => Tooltip(
                  message: lab!.module.name,
                  enableFeedback: true,
                  triggerMode:
                      provider.enabled ? TooltipTriggerMode.tap : TooltipTriggerMode.manual,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Icon(
                            lab!.getIcon(),
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Consumer<ModuleCodeStyleProvider>(
                                builder: (ctx, provider, child) => Text(
                                      lab!.module.getModuleCodeWithStyle(provider.style),
                                      style: GoogleFonts.openSans(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                          fontWeight: FontWeight.w700),
                                    )),
                            Text(
                              lab!.getStartTime() + " - " + lab!.getEndTime(),
                              style: GoogleFonts.openSans(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                          ],
                        )
                      ])),
                )));
  }
}
