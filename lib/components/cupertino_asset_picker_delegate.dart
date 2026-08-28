import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// Делегат `wechat_assets_picker` c кнопкой «Подтвердить» в стиле iOS.
///
/// Плагин строит confirm-кнопку как [MaterialButton] прямо в
/// [DefaultAssetPickerBuilderDelegate.confirmButton], и отдельного хука на её
/// замену нет — поэтому переопределяем метод и возвращаем [CupertinoButton].
/// Запускать через [AssetPicker.pickAssetsWithDelegate].
///
/// Важно: базовая раскладка показывает confirm-кнопку только когда
/// `maxAssets > 1` (`if (!isSingleAssetMode) confirmButton(...)`). При
/// `maxAssets == 1` выбор подтверждается сразу по тапу и кнопка не рисуется.
class CupertinoAssetPickerDelegate extends DefaultAssetPickerBuilderDelegate {
  CupertinoAssetPickerDelegate({
    required super.provider,
    required super.initialPermission,
    super.gridCount,
    super.pickerTheme,
    super.themeColor,
    super.limitedPermissionOverlayPredicate,
    // По локали базовый делегат сам подберёт textDelegate
    // (assetPickerTextDelegateFromLocale) — иначе тексты будут на китайском.
    super.locale,
  });

  @override
  Widget confirmButton(BuildContext context) {
    // provider — ChangeNotifier делегата; слушаем его напрямую, чтобы не тянуть
    // пакет provider ради Consumer.
    return ListenableBuilder(
      listenable: provider,
      builder: (context, _) {
        final canConfirm = provider.isSelectedNotEmpty || provider.previousSelectedAssets.isNotEmpty;
        // themeColor и pickerTheme взаимоисключающие; когда задан pickerTheme,
        // акцентный цвет берём из неё (colorScheme.secondary).
        final accentColor = themeColor ?? theme.colorScheme.secondary;
        return CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          minimumSize: Size.zero,
          onPressed: canConfirm ? () => Navigator.maybeOf(context)?.maybePop(provider.selectedAssets) : null,
          child: Text(
            provider.isSelectedNotEmpty && !isSingleAssetMode
                ? '${textDelegate.confirm} (${provider.selectedAssets.length}/${provider.maxAssets})'
                : textDelegate.confirm,
            style: TextStyle(fontSize: 17, color: canConfirm ? accentColor : CupertinoColors.inactiveGray.resolveFrom(context)),
          ),
        );
      },
    );
  }
}
