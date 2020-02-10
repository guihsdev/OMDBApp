// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'omdb_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OmdbStore on _OmdbStoreBase, Store {
  Computed<Films> _$filmComputed;

  @override
  Films get film =>
      (_$filmComputed ??= Computed<Films>(() => super.film)).value;
  Computed<List<Films>> _$favFilmsComputed;

  @override
  List<Films> get favFilms =>
      (_$favFilmsComputed ??= Computed<List<Films>>(() => super.favFilms))
          .value;
  Computed<List<Films>> _$localFilmsComputed;

  @override
  List<Films> get localFilms =>
      (_$localFilmsComputed ??= Computed<List<Films>>(() => super.localFilms))
          .value;
  Computed<Films> _$imdbFilmComputed;

  @override
  Films get imdbFilm =>
      (_$imdbFilmComputed ??= Computed<Films>(() => super.imdbFilm)).value;
  Computed<int> _$respondeFavFilmComputed;

  @override
  int get respondeFavFilm =>
      (_$respondeFavFilmComputed ??= Computed<int>(() => super.respondeFavFilm))
          .value;
  Computed<int> _$favValueComputed;

  @override
  int get favValue =>
      (_$favValueComputed ??= Computed<int>(() => super.favValue)).value;
  Computed<List<Films>> _$filmsByTitleYearComputed;

  @override
  List<Films> get filmsByTitleYear => (_$filmsByTitleYearComputed ??=
          Computed<List<Films>>(() => super.filmsByTitleYear))
      .value;

  final _$_filmAtom = Atom(name: '_OmdbStoreBase._film');

  @override
  Films get _film {
    _$_filmAtom.context.enforceReadPolicy(_$_filmAtom);
    _$_filmAtom.reportObserved();
    return super._film;
  }

  @override
  set _film(Films value) {
    _$_filmAtom.context.conditionallyRunInAction(() {
      super._film = value;
      _$_filmAtom.reportChanged();
    }, _$_filmAtom, name: '${_$_filmAtom.name}_set');
  }

  final _$_listFavFilmsAtom = Atom(name: '_OmdbStoreBase._listFavFilms');

  @override
  List<Films> get _listFavFilms {
    _$_listFavFilmsAtom.context.enforceReadPolicy(_$_listFavFilmsAtom);
    _$_listFavFilmsAtom.reportObserved();
    return super._listFavFilms;
  }

  @override
  set _listFavFilms(List<Films> value) {
    _$_listFavFilmsAtom.context.conditionallyRunInAction(() {
      super._listFavFilms = value;
      _$_listFavFilmsAtom.reportChanged();
    }, _$_listFavFilmsAtom, name: '${_$_listFavFilmsAtom.name}_set');
  }

  final _$_listLocalFilmsAtom = Atom(name: '_OmdbStoreBase._listLocalFilms');

  @override
  List<Films> get _listLocalFilms {
    _$_listLocalFilmsAtom.context.enforceReadPolicy(_$_listLocalFilmsAtom);
    _$_listLocalFilmsAtom.reportObserved();
    return super._listLocalFilms;
  }

  @override
  set _listLocalFilms(List<Films> value) {
    _$_listLocalFilmsAtom.context.conditionallyRunInAction(() {
      super._listLocalFilms = value;
      _$_listLocalFilmsAtom.reportChanged();
    }, _$_listLocalFilmsAtom, name: '${_$_listLocalFilmsAtom.name}_set');
  }

  final _$_imdbFilmAtom = Atom(name: '_OmdbStoreBase._imdbFilm');

  @override
  Films get _imdbFilm {
    _$_imdbFilmAtom.context.enforceReadPolicy(_$_imdbFilmAtom);
    _$_imdbFilmAtom.reportObserved();
    return super._imdbFilm;
  }

  @override
  set _imdbFilm(Films value) {
    _$_imdbFilmAtom.context.conditionallyRunInAction(() {
      super._imdbFilm = value;
      _$_imdbFilmAtom.reportChanged();
    }, _$_imdbFilmAtom, name: '${_$_imdbFilmAtom.name}_set');
  }

  final _$_resFavAtom = Atom(name: '_OmdbStoreBase._resFav');

  @override
  int get _resFav {
    _$_resFavAtom.context.enforceReadPolicy(_$_resFavAtom);
    _$_resFavAtom.reportObserved();
    return super._resFav;
  }

  @override
  set _resFav(int value) {
    _$_resFavAtom.context.conditionallyRunInAction(() {
      super._resFav = value;
      _$_resFavAtom.reportChanged();
    }, _$_resFavAtom, name: '${_$_resFavAtom.name}_set');
  }

  final _$_favValueAtom = Atom(name: '_OmdbStoreBase._favValue');

  @override
  int get _favValue {
    _$_favValueAtom.context.enforceReadPolicy(_$_favValueAtom);
    _$_favValueAtom.reportObserved();
    return super._favValue;
  }

  @override
  set _favValue(int value) {
    _$_favValueAtom.context.conditionallyRunInAction(() {
      super._favValue = value;
      _$_favValueAtom.reportChanged();
    }, _$_favValueAtom, name: '${_$_favValueAtom.name}_set');
  }

  final _$_listFilmsByTitleYearAtom =
      Atom(name: '_OmdbStoreBase._listFilmsByTitleYear');

  @override
  List<Films> get _listFilmsByTitleYear {
    _$_listFilmsByTitleYearAtom.context
        .enforceReadPolicy(_$_listFilmsByTitleYearAtom);
    _$_listFilmsByTitleYearAtom.reportObserved();
    return super._listFilmsByTitleYear;
  }

  @override
  set _listFilmsByTitleYear(List<Films> value) {
    _$_listFilmsByTitleYearAtom.context.conditionallyRunInAction(() {
      super._listFilmsByTitleYear = value;
      _$_listFilmsByTitleYearAtom.reportChanged();
    }, _$_listFilmsByTitleYearAtom,
        name: '${_$_listFilmsByTitleYearAtom.name}_set');
  }

  final _$_OmdbStoreBaseActionController =
      ActionController(name: '_OmdbStoreBase');

  @override
  dynamic fetchFilmApi({String ano, String filme, String plot}) {
    final _$actionInfo = _$_OmdbStoreBaseActionController.startAction();
    try {
      return super.fetchFilmApi(ano: ano, filme: filme, plot: plot);
    } finally {
      _$_OmdbStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic fetchFavsFilms() {
    final _$actionInfo = _$_OmdbStoreBaseActionController.startAction();
    try {
      return super.fetchFavsFilms();
    } finally {
      _$_OmdbStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic fetchLocalFilms() {
    final _$actionInfo = _$_OmdbStoreBaseActionController.startAction();
    try {
      return super.fetchLocalFilms();
    } finally {
      _$_OmdbStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic fetchFilmsByImdbId({String imdbId}) {
    final _$actionInfo = _$_OmdbStoreBaseActionController.startAction();
    try {
      return super.fetchFilmsByImdbId(imdbId: imdbId);
    } finally {
      _$_OmdbStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFavFilm({int fav, String imdbID}) {
    final _$actionInfo = _$_OmdbStoreBaseActionController.startAction();
    try {
      return super.setFavFilm(fav: fav, imdbID: imdbID);
    } finally {
      _$_OmdbStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFavValue({int fav}) {
    final _$actionInfo = _$_OmdbStoreBaseActionController.startAction();
    try {
      return super.setFavValue(fav: fav);
    } finally {
      _$_OmdbStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic fetchFilmsByTitleYear({String title, dynamic year}) {
    final _$actionInfo = _$_OmdbStoreBaseActionController.startAction();
    try {
      return super.fetchFilmsByTitleYear(title: title, year: year);
    } finally {
      _$_OmdbStoreBaseActionController.endAction(_$actionInfo);
    }
  }
}
