defmodule LFSR do
  @moduledoc """
  Implements a binary Galois Linear Feedback Shift Register with arbitrary size `n`.

  A LFSR is a shift register whose input bit is a linear function of its previous state.

  The bit positions that affect the next state are called the taps.

  A LFSR with well chosen taps will produce a maximum cycle, meaning that a register
  with size `n` will produce a sequence of length 2<sup>n</sup>-1 without repetitions.

  The LFSR can be initialized by providing a starting state and the desired size of
  the register. In this case, a table of default taps that generate the maximum cycle
  is used.

  Alternatively, the LFSR can be initialized with the starting state and a
  list of taps. Note however that not all combinations of taps will produce the
  maximum cycle.
  """

  import Bitwise

  defstruct [:state, :mask]

  @doc """
  Initializes and returns a new LFSR. The LFSR is represented using a Struct.

  The first argument is the starting state and must be a number greater than 0 and
  less than 2<sup>n</sup>, where `n` is the size of the register.

  The second argument is either the size in bits of the register or a list of taps.

  ## Examples

      iex> LFSR.new(1, 8)
      %LFSR{mask: 184, state: 1}

      iex> LFSR.new(1, [8, 6, 5, 4])
      %LFSR{mask: 184, state: 1}
  """
  def new(state, size) when is_integer(state) and is_integer(size) do
    new(state, taps(size))
  end

  def new(state, [size | _] = taps) when is_integer(state) and is_integer(size) do
    limit = 1 <<< size
    if state <= 0 or state >= limit do
      raise ArgumentError, message: "initial state must be between 1 and #{limit - 1}"
    end
    struct(__MODULE__, state: state, mask: mask(size, taps))
  end

  @doc """
  Takes the LFSR and returns the LFSR in the next state.

  ## Examples

      iex> LFSR.new(1, 8)
      %LFSR{mask: 184, state: 1}

      iex> LFSR.new(1, 8) |> LFSR.next
      %LFSR{mask: 184, state: 184}
  """
  def next(%__MODULE__{state: state, mask: mask} = lfsr) do
    lsb = state &&& 1
    state = state >>> 1
    state = if lsb == 1, do: state ^^^ mask, else: state
    %{lfsr | state: state}
  end

  @doc """
  Convenience function to fetch the state of a LFSR.

  ## Examples

      iex> LFSR.new(1, 8) |> LFSR.state
      1
  """
  def state(%__MODULE__{state: state}), do: state

  defp mask(size, taps) do
    <<mask::size(size)>> = Enum.reduce(taps, <<0::size(size)>>, &(set_bit(&2, size - &1)))
    mask
  end

  defp set_bit(bits, pos) do
    <<left::size(pos), _::1, right::bitstring>> = bits
    <<left::size(pos), 1::1, right::bitstring>>
  end

  # http://www.eej.ulst.ac.uk/~ian/modules/EEE515/files/old_files/lfsr/lfsr_table.pdf
  defp taps(2),    do: [2, 1]
  defp taps(3),    do: [3, 2]
  defp taps(4),    do: [4, 3]
  defp taps(5),    do: [5, 4, 3, 2]
  defp taps(6),    do: [6, 5, 3, 2]
  defp taps(7),    do: [7, 6, 5, 4]
  defp taps(8),    do: [8, 6, 5, 4]
  defp taps(9),    do: [9, 8, 6, 5]
  defp taps(10),   do: [10, 9, 7, 6]
  defp taps(11),   do: [11, 10, 9, 7]
  defp taps(12),   do: [12, 11, 8, 6]
  defp taps(13),   do: [13, 12, 10, 9]
  defp taps(14),   do: [14, 13, 11, 9]
  defp taps(15),   do: [15, 14, 13, 11]
  defp taps(16),   do: [16, 14, 13, 11]
  defp taps(17),   do: [17, 16, 15, 14]
  defp taps(18),   do: [18, 17, 16, 13]
  defp taps(19),   do: [19, 18, 17, 14]
  defp taps(20),   do: [20, 19, 16, 14]
  defp taps(21),   do: [21, 20, 19, 16]
  defp taps(22),   do: [22, 19, 18, 17]
  defp taps(23),   do: [23, 22, 20, 18]
  defp taps(24),   do: [24, 23, 21, 20]
  defp taps(25),   do: [25, 24, 23, 22]
  defp taps(26),   do: [26, 25, 24, 20]
  defp taps(27),   do: [27, 26, 25, 22]
  defp taps(28),   do: [28, 27, 24, 22]
  defp taps(29),   do: [29, 28, 27, 25]
  defp taps(30),   do: [30, 29, 26, 24]
  defp taps(31),   do: [31, 30, 29, 28]
  defp taps(32),   do: [32, 30, 26, 25]
  defp taps(33),   do: [33, 32, 29, 27]
  defp taps(34),   do: [34, 31, 30, 26]
  defp taps(35),   do: [35, 34, 28, 27]
  defp taps(36),   do: [36, 35, 29, 28]
  defp taps(37),   do: [37, 36, 33, 31]
  defp taps(38),   do: [38, 37, 33, 32]
  defp taps(39),   do: [39, 38, 35, 32]
  defp taps(40),   do: [40, 37, 36, 35]
  defp taps(41),   do: [41, 40, 39, 38]
  defp taps(42),   do: [42, 40, 37, 35]
  defp taps(43),   do: [43, 42, 38, 37]
  defp taps(44),   do: [44, 42, 39, 38]
  defp taps(45),   do: [45, 44, 42, 41]
  defp taps(46),   do: [46, 40, 39, 38]
  defp taps(47),   do: [47, 46, 43, 42]
  defp taps(48),   do: [48, 44, 41, 39]
  defp taps(49),   do: [49, 45, 44, 43]
  defp taps(50),   do: [50, 48, 47, 46]
  defp taps(51),   do: [51, 50, 48, 45]
  defp taps(52),   do: [52, 51, 49, 46]
  defp taps(53),   do: [53, 52, 51, 47]
  defp taps(54),   do: [54, 51, 48, 46]
  defp taps(55),   do: [55, 54, 53, 49]
  defp taps(56),   do: [56, 54, 52, 49]
  defp taps(57),   do: [57, 55, 54, 52]
  defp taps(58),   do: [58, 57, 53, 52]
  defp taps(59),   do: [59, 57, 55, 52]
  defp taps(60),   do: [60, 58, 56, 55]
  defp taps(61),   do: [61, 60, 59, 56]
  defp taps(62),   do: [62, 59, 57, 56]
  defp taps(63),   do: [63, 62, 59, 58]
  defp taps(64),   do: [64, 63, 61, 60]
  defp taps(65),   do: [65, 64, 62, 61]
  defp taps(66),   do: [66, 60, 58, 57]
  defp taps(67),   do: [67, 66, 65, 62]
  defp taps(68),   do: [68, 67, 63, 61]
  defp taps(69),   do: [69, 67, 64, 63]
  defp taps(70),   do: [70, 69, 67, 65]
  defp taps(71),   do: [71, 70, 68, 66]
  defp taps(72),   do: [72, 69, 63, 62]
  defp taps(73),   do: [73, 71, 70, 69]
  defp taps(74),   do: [74, 71, 70, 67]
  defp taps(75),   do: [75, 74, 72, 69]
  defp taps(76),   do: [76, 74, 72, 71]
  defp taps(77),   do: [77, 75, 72, 71]
  defp taps(78),   do: [78, 77, 76, 71]
  defp taps(79),   do: [79, 77, 76, 75]
  defp taps(80),   do: [80, 78, 76, 71]
  defp taps(81),   do: [81, 79, 78, 75]
  defp taps(82),   do: [82, 78, 76, 73]
  defp taps(83),   do: [83, 81, 79, 76]
  defp taps(84),   do: [84, 83, 77, 75]
  defp taps(85),   do: [85, 84, 83, 77]
  defp taps(86),   do: [86, 84, 81, 80]
  defp taps(87),   do: [87, 86, 82, 80]
  defp taps(88),   do: [88, 80, 79, 77]
  defp taps(89),   do: [89, 86, 84, 83]
  defp taps(90),   do: [90, 88, 87, 85]
  defp taps(91),   do: [91, 90, 86, 83]
  defp taps(92),   do: [92, 90, 87, 86]
  defp taps(93),   do: [93, 91, 90, 87]
  defp taps(94),   do: [94, 93, 89, 88]
  defp taps(95),   do: [95, 94, 90, 88]
  defp taps(96),   do: [96, 90, 87, 86]
  defp taps(97),   do: [97, 95, 93, 91]
  defp taps(98),   do: [98, 97, 91, 90]
  defp taps(99),   do: [99, 95, 94, 92]
  defp taps(100),  do: [100, 98, 93, 92]
  defp taps(101),  do: [101, 100, 95, 94]
  defp taps(102),  do: [102, 99, 97, 96]
  defp taps(103),  do: [103, 102, 99, 94]
  defp taps(104),  do: [104, 103, 94, 93]
  defp taps(105),  do: [105, 104, 99, 98]
  defp taps(106),  do: [106, 105, 101, 100]
  defp taps(107),  do: [107, 105, 99, 98]
  defp taps(108),  do: [108, 103, 97, 96]
  defp taps(109),  do: [109, 107, 105, 104]
  defp taps(110),  do: [110, 109, 106, 104]
  defp taps(111),  do: [111, 109, 107, 104]
  defp taps(112),  do: [112, 108, 106, 101]
  defp taps(113),  do: [113, 111, 110, 108]
  defp taps(114),  do: [114, 113, 112, 103]
  defp taps(115),  do: [115, 110, 108, 107]
  defp taps(116),  do: [116, 114, 111, 110]
  defp taps(117),  do: [117, 116, 115, 112]
  defp taps(118),  do: [118, 116, 113, 112]
  defp taps(119),  do: [119, 116, 111, 110]
  defp taps(120),  do: [120, 118, 114, 111]
  defp taps(121),  do: [121, 120, 116, 113]
  defp taps(122),  do: [122, 121, 120, 116]
  defp taps(123),  do: [123, 122, 119, 115]
  defp taps(124),  do: [124, 119, 118, 117]
  defp taps(125),  do: [125, 120, 119, 118]
  defp taps(126),  do: [126, 124, 122, 119]
  defp taps(127),  do: [127, 126, 124, 120]
  defp taps(128),  do: [128, 127, 126, 121]
  defp taps(129),  do: [129, 128, 125, 124]
  defp taps(130),  do: [130, 129, 128, 125]
  defp taps(131),  do: [131, 129, 128, 123]
  defp taps(132),  do: [132, 130, 127, 123]
  defp taps(133),  do: [133, 131, 125, 124]
  defp taps(134),  do: [134, 133, 129, 127]
  defp taps(135),  do: [135, 132, 131, 129]
  defp taps(136),  do: [136, 134, 133, 128]
  defp taps(137),  do: [137, 136, 133, 126]
  defp taps(138),  do: [138, 137, 131, 130]
  defp taps(139),  do: [139, 136, 134, 131]
  defp taps(140),  do: [140, 139, 136, 132]
  defp taps(141),  do: [141, 140, 135, 128]
  defp taps(142),  do: [142, 141, 139, 132]
  defp taps(143),  do: [143, 141, 140, 138]
  defp taps(144),  do: [144, 142, 140, 137]
  defp taps(145),  do: [145, 144, 140, 139]
  defp taps(146),  do: [146, 144, 143, 141]
  defp taps(147),  do: [147, 145, 143, 136]
  defp taps(148),  do: [148, 145, 143, 141]
  defp taps(149),  do: [149, 142, 140, 139]
  defp taps(150),  do: [150, 148, 147, 142]
  defp taps(151),  do: [151, 150, 149, 148]
  defp taps(152),  do: [152, 150, 149, 146]
  defp taps(153),  do: [153, 149, 148, 145]
  defp taps(154),  do: [154, 153, 149, 145]
  defp taps(155),  do: [155, 151, 150, 148]
  defp taps(156),  do: [156, 153, 151, 147]
  defp taps(157),  do: [157, 155, 152, 151]
  defp taps(158),  do: [158, 153, 152, 150]
  defp taps(159),  do: [159, 156, 153, 148]
  defp taps(160),  do: [160, 158, 157, 155]
  defp taps(161),  do: [161, 159, 158, 155]
  defp taps(162),  do: [162, 158, 155, 154]
  defp taps(163),  do: [163, 160, 157, 156]
  defp taps(164),  do: [164, 159, 158, 152]
  defp taps(165),  do: [165, 162, 157, 156]
  defp taps(166),  do: [166, 164, 163, 156]
  defp taps(167),  do: [167, 165, 163, 161]
  defp taps(168),  do: [168, 162, 159, 152]
  defp taps(169),  do: [169, 164, 163, 161]
  defp taps(170),  do: [170, 169, 166, 161]
  defp taps(171),  do: [171, 169, 166, 165]
  defp taps(172),  do: [172, 169, 165, 161]
  defp taps(173),  do: [173, 171, 168, 165]
  defp taps(174),  do: [174, 169, 166, 165]
  defp taps(175),  do: [175, 173, 171, 169]
  defp taps(176),  do: [176, 167, 165, 164]
  defp taps(177),  do: [177, 175, 174, 172]
  defp taps(178),  do: [178, 176, 171, 170]
  defp taps(179),  do: [179, 178, 177, 175]
  defp taps(180),  do: [180, 173, 170, 168]
  defp taps(181),  do: [181, 180, 175, 174]
  defp taps(182),  do: [182, 181, 176, 174]
  defp taps(183),  do: [183, 179, 176, 175]
  defp taps(184),  do: [184, 177, 176, 175]
  defp taps(185),  do: [185, 184, 182, 177]
  defp taps(186),  do: [186, 180, 178, 177]
  defp taps(187),  do: [187, 182, 181, 180]
  defp taps(188),  do: [188, 186, 183, 182]
  defp taps(189),  do: [189, 187, 184, 183]
  defp taps(190),  do: [190, 188, 184, 177]
  defp taps(191),  do: [191, 187, 185, 184]
  defp taps(192),  do: [192, 190, 178, 177]
  defp taps(193),  do: [193, 189, 186, 184]
  defp taps(194),  do: [194, 192, 191, 190]
  defp taps(195),  do: [195, 193, 192, 187]
  defp taps(196),  do: [196, 194, 187, 185]
  defp taps(197),  do: [197, 195, 193, 188]
  defp taps(198),  do: [198, 193, 190, 183]
  defp taps(199),  do: [199, 198, 195, 190]
  defp taps(200),  do: [200, 198, 197, 195]
  defp taps(201),  do: [201, 199, 198, 195]
  defp taps(202),  do: [202, 198, 196, 195]
  defp taps(203),  do: [203, 202, 196, 195]
  defp taps(204),  do: [204, 201, 200, 194]
  defp taps(205),  do: [205, 203, 200, 196]
  defp taps(206),  do: [206, 201, 197, 196]
  defp taps(207),  do: [207, 206, 201, 198]
  defp taps(208),  do: [208, 207, 205, 199]
  defp taps(209),  do: [209, 207, 206, 204]
  defp taps(210),  do: [210, 207, 206, 198]
  defp taps(211),  do: [211, 203, 201, 200]
  defp taps(212),  do: [212, 209, 208, 205]
  defp taps(213),  do: [213, 211, 208, 207]
  defp taps(214),  do: [214, 213, 211, 209]
  defp taps(215),  do: [215, 212, 210, 209]
  defp taps(216),  do: [216, 215, 213, 209]
  defp taps(217),  do: [217, 213, 212, 211]
  defp taps(218),  do: [218, 217, 211, 210]
  defp taps(219),  do: [219, 218, 215, 211]
  defp taps(220),  do: [220, 211, 210, 208]
  defp taps(221),  do: [221, 219, 215, 213]
  defp taps(222),  do: [222, 220, 217, 214]
  defp taps(223),  do: [223, 221, 219, 218]
  defp taps(224),  do: [224, 222, 217, 212]
  defp taps(225),  do: [225, 224, 220, 215]
  defp taps(226),  do: [226, 223, 219, 216]
  defp taps(227),  do: [227, 223, 218, 217]
  defp taps(228),  do: [228, 226, 217, 216]
  defp taps(229),  do: [229, 228, 225, 219]
  defp taps(230),  do: [230, 224, 223, 222]
  defp taps(231),  do: [231, 229, 227, 224]
  defp taps(232),  do: [232, 228, 223, 221]
  defp taps(233),  do: [233, 232, 229, 224]
  defp taps(234),  do: [234, 232, 225, 223]
  defp taps(235),  do: [235, 234, 229, 226]
  defp taps(236),  do: [236, 229, 228, 226]
  defp taps(237),  do: [237, 236, 233, 230]
  defp taps(238),  do: [238, 237, 236, 233]
  defp taps(239),  do: [239, 238, 232, 227]
  defp taps(240),  do: [240, 237, 235, 232]
  defp taps(241),  do: [241, 237, 233, 232]
  defp taps(242),  do: [242, 241, 236, 231]
  defp taps(243),  do: [243, 242, 238, 235]
  defp taps(244),  do: [244, 243, 240, 235]
  defp taps(245),  do: [245, 244, 241, 239]
  defp taps(246),  do: [246, 245, 244, 235]
  defp taps(247),  do: [247, 245, 243, 238]
  defp taps(248),  do: [248, 238, 234, 233]
  defp taps(249),  do: [249, 248, 245, 242]
  defp taps(250),  do: [250, 247, 245, 240]
  defp taps(251),  do: [251, 249, 247, 244]
  defp taps(252),  do: [252, 251, 247, 241]
  defp taps(253),  do: [253, 252, 247, 246]
  defp taps(254),  do: [254, 253, 252, 247]
  defp taps(255),  do: [255, 253, 252, 250]
  defp taps(256),  do: [256, 254, 251, 246]
  defp taps(257),  do: [257, 255, 251, 250]
  defp taps(258),  do: [258, 254, 252, 249]
  defp taps(259),  do: [259, 257, 253, 249]
  defp taps(260),  do: [260, 253, 252, 250]
  defp taps(261),  do: [261, 257, 255, 254]
  defp taps(262),  do: [262, 258, 254, 253]
  defp taps(263),  do: [263, 261, 258, 252]
  defp taps(264),  do: [264, 263, 255, 254]
  defp taps(265),  do: [265, 263, 262, 260]
  defp taps(266),  do: [266, 265, 260, 259]
  defp taps(267),  do: [267, 264, 261, 259]
  defp taps(268),  do: [268, 267, 264, 258]
  defp taps(269),  do: [269, 268, 263, 262]
  defp taps(270),  do: [270, 267, 263, 260]
  defp taps(271),  do: [271, 265, 264, 260]
  defp taps(272),  do: [272, 270, 266, 263]
  defp taps(273),  do: [273, 272, 271, 266]
  defp taps(274),  do: [274, 272, 267, 265]
  defp taps(275),  do: [275, 266, 265, 264]
  defp taps(276),  do: [276, 275, 273, 270]
  defp taps(277),  do: [277, 274, 271, 265]
  defp taps(278),  do: [278, 277, 274, 273]
  defp taps(279),  do: [279, 278, 275, 274]
  defp taps(280),  do: [280, 278, 275, 271]
  defp taps(281),  do: [281, 280, 277, 272]
  defp taps(282),  do: [282, 278, 277, 272]
  defp taps(283),  do: [283, 278, 276, 271]
  defp taps(284),  do: [284, 279, 278, 276]
  defp taps(285),  do: [285, 280, 278, 275]
  defp taps(286),  do: [286, 285, 276, 271]
  defp taps(287),  do: [287, 285, 282, 281]
  defp taps(288),  do: [288, 287, 278, 277]
  defp taps(289),  do: [289, 286, 285, 277]
  defp taps(290),  do: [290, 288, 287, 285]
  defp taps(291),  do: [291, 286, 280, 279]
  defp taps(292),  do: [292, 291, 289, 285]
  defp taps(293),  do: [293, 292, 287, 282]
  defp taps(294),  do: [294, 292, 291, 285]
  defp taps(295),  do: [295, 293, 291, 290]
  defp taps(296),  do: [296, 292, 287, 285]
  defp taps(297),  do: [297, 296, 293, 292]
  defp taps(298),  do: [298, 294, 290, 287]
  defp taps(299),  do: [299, 295, 293, 288]
  defp taps(300),  do: [300, 290, 288, 287]
  defp taps(301),  do: [301, 299, 296, 292]
  defp taps(302),  do: [302, 297, 293, 290]
  defp taps(303),  do: [303, 297, 291, 290]
  defp taps(304),  do: [304, 303, 302, 293]
  defp taps(305),  do: [305, 303, 299, 298]
  defp taps(306),  do: [306, 305, 303, 299]
  defp taps(307),  do: [307, 305, 303, 299]
  defp taps(308),  do: [308, 306, 299, 293]
  defp taps(309),  do: [309, 307, 302, 299]
  defp taps(310),  do: [310, 309, 305, 302]
  defp taps(311),  do: [311, 308, 306, 304]
  defp taps(312),  do: [312, 307, 302, 301]
  defp taps(313),  do: [313, 312, 310, 306]
  defp taps(314),  do: [314, 311, 305, 300]
  defp taps(315),  do: [315, 314, 306, 305]
  defp taps(316),  do: [316, 309, 305, 304]
  defp taps(317),  do: [317, 315, 313, 310]
  defp taps(318),  do: [318, 313, 312, 310]
  defp taps(319),  do: [319, 318, 317, 308]
  defp taps(320),  do: [320, 319, 317, 316]
  defp taps(321),  do: [321, 319, 316, 314]
  defp taps(322),  do: [322, 321, 320, 305]
  defp taps(323),  do: [323, 322, 320, 313]
  defp taps(324),  do: [324, 321, 320, 318]
  defp taps(325),  do: [325, 323, 320, 315]
  defp taps(326),  do: [326, 325, 323, 316]
  defp taps(327),  do: [327, 325, 322, 319]
  defp taps(328),  do: [328, 323, 321, 319]
  defp taps(329),  do: [329, 326, 323, 321]
  defp taps(330),  do: [330, 328, 323, 322]
  defp taps(331),  do: [331, 329, 325, 321]
  defp taps(332),  do: [332, 325, 321, 320]
  defp taps(333),  do: [333, 331, 329, 325]
  defp taps(334),  do: [334, 333, 330, 327]
  defp taps(335),  do: [335, 333, 328, 325]
  defp taps(336),  do: [336, 335, 332, 329]
  defp taps(337),  do: [337, 336, 331, 327]
  defp taps(338),  do: [338, 336, 335, 332]
  defp taps(339),  do: [339, 332, 329, 323]
  defp taps(340),  do: [340, 337, 336, 329]
  defp taps(341),  do: [341, 336, 330, 327]
  defp taps(342),  do: [342, 341, 340, 331]
  defp taps(343),  do: [343, 338, 335, 333]
  defp taps(344),  do: [344, 338, 334, 333]
  defp taps(345),  do: [345, 343, 341, 337]
  defp taps(346),  do: [346, 344, 339, 335]
  defp taps(347),  do: [347, 344, 337, 336]
  defp taps(348),  do: [348, 344, 341, 340]
  defp taps(349),  do: [349, 347, 344, 343]
  defp taps(350),  do: [350, 340, 337, 336]
  defp taps(351),  do: [351, 348, 345, 343]
  defp taps(352),  do: [352, 346, 341, 339]
  defp taps(353),  do: [353, 349, 346, 344]
  defp taps(354),  do: [354, 349, 341, 340]
  defp taps(355),  do: [355, 354, 350, 349]
  defp taps(356),  do: [356, 349, 347, 346]
  defp taps(357),  do: [357, 355, 347, 346]
  defp taps(358),  do: [358, 351, 350, 344]
  defp taps(359),  do: [359, 358, 352, 350]
  defp taps(360),  do: [360, 359, 335, 334]
  defp taps(361),  do: [361, 360, 357, 354]
  defp taps(362),  do: [362, 360, 351, 344]
  defp taps(363),  do: [363, 362, 356, 355]
  defp taps(364),  do: [364, 363, 359, 352]
  defp taps(365),  do: [365, 360, 359, 356]
  defp taps(366),  do: [366, 362, 359, 352]
  defp taps(367),  do: [367, 365, 363, 358]
  defp taps(368),  do: [368, 361, 359, 351]
  defp taps(369),  do: [369, 367, 359, 358]
  defp taps(370),  do: [370, 368, 367, 365]
  defp taps(371),  do: [371, 369, 368, 363]
  defp taps(372),  do: [372, 369, 365, 357]
  defp taps(373),  do: [373, 371, 366, 365]
  defp taps(374),  do: [374, 369, 368, 366]
  defp taps(375),  do: [375, 374, 368, 367]
  defp taps(376),  do: [376, 371, 369, 368]
  defp taps(377),  do: [377, 376, 374, 369]
  defp taps(378),  do: [378, 374, 365, 363]
  defp taps(379),  do: [379, 375, 370, 369]
  defp taps(380),  do: [380, 377, 374, 366]
  defp taps(381),  do: [381, 380, 379, 376]
  defp taps(382),  do: [382, 379, 375, 364]
  defp taps(383),  do: [383, 382, 378, 374]
  defp taps(384),  do: [384, 378, 369, 368]
  defp taps(385),  do: [385, 383, 381, 379]
  defp taps(386),  do: [386, 381, 380, 376]
  defp taps(387),  do: [387, 385, 379, 378]
  defp taps(388),  do: [388, 387, 385, 374]
  defp taps(389),  do: [389, 384, 380, 379]
  defp taps(390),  do: [390, 388, 380, 377]
  defp taps(391),  do: [391, 390, 389, 385]
  defp taps(392),  do: [392, 386, 382, 379]
  defp taps(393),  do: [393, 392, 391, 386]
  defp taps(394),  do: [394, 392, 387, 386]
  defp taps(395),  do: [395, 390, 389, 384]
  defp taps(396),  do: [396, 392, 390, 389]
  defp taps(397),  do: [397, 392, 387, 385]
  defp taps(398),  do: [398, 393, 392, 384]
  defp taps(399),  do: [399, 397, 390, 388]
  defp taps(400),  do: [400, 398, 397, 395]
  defp taps(401),  do: [401, 399, 392, 389]
  defp taps(402),  do: [402, 399, 398, 393]
  defp taps(403),  do: [403, 398, 395, 394]
  defp taps(404),  do: [404, 400, 398, 397]
  defp taps(405),  do: [405, 398, 397, 388]
  defp taps(406),  do: [406, 402, 397, 393]
  defp taps(407),  do: [407, 402, 400, 398]
  defp taps(408),  do: [408, 407, 403, 401]
  defp taps(409),  do: [409, 406, 404, 402]
  defp taps(410),  do: [410, 407, 406, 400]
  defp taps(411),  do: [411, 408, 401, 399]
  defp taps(412),  do: [412, 409, 404, 401]
  defp taps(413),  do: [413, 407, 406, 403]
  defp taps(414),  do: [414, 405, 401, 398]
  defp taps(415),  do: [415, 413, 411, 406]
  defp taps(416),  do: [416, 414, 411, 407]
  defp taps(417),  do: [417, 416, 414, 407]
  defp taps(418),  do: [418, 417, 415, 403]
  defp taps(419),  do: [419, 415, 414, 404]
  defp taps(420),  do: [420, 412, 410, 407]
  defp taps(421),  do: [421, 419, 417, 416]
  defp taps(422),  do: [422, 421, 416, 412]
  defp taps(423),  do: [423, 420, 418, 414]
  defp taps(424),  do: [424, 422, 417, 415]
  defp taps(425),  do: [425, 422, 421, 418]
  defp taps(426),  do: [426, 415, 414, 412]
  defp taps(427),  do: [427, 422, 421, 416]
  defp taps(428),  do: [428, 426, 425, 417]
  defp taps(429),  do: [429, 422, 421, 419]
  defp taps(430),  do: [430, 419, 417, 415]
  defp taps(431),  do: [431, 430, 428, 426]
  defp taps(432),  do: [432, 429, 428, 419]
  defp taps(433),  do: [433, 430, 428, 422]
  defp taps(434),  do: [434, 429, 423, 422]
  defp taps(435),  do: [435, 430, 426, 423]
  defp taps(436),  do: [436, 432, 431, 430]
  defp taps(437),  do: [437, 436, 435, 431]
  defp taps(438),  do: [438, 436, 432, 421]
  defp taps(439),  do: [439, 437, 436, 431]
  defp taps(440),  do: [440, 439, 437, 436]
  defp taps(441),  do: [441, 440, 433, 430]
  defp taps(442),  do: [442, 440, 437, 435]
  defp taps(443),  do: [443, 442, 437, 433]
  defp taps(444),  do: [444, 435, 432, 431]
  defp taps(445),  do: [445, 441, 439, 438]
  defp taps(446),  do: [446, 442, 439, 431]
  defp taps(447),  do: [447, 446, 441, 438]
  defp taps(448),  do: [448, 444, 442, 437]
  defp taps(449),  do: [449, 446, 440, 438]
  defp taps(450),  do: [450, 443, 438, 434]
  defp taps(451),  do: [451, 450, 441, 435]
  defp taps(452),  do: [452, 448, 447, 446]
  defp taps(453),  do: [453, 449, 447, 438]
  defp taps(454),  do: [454, 449, 445, 444]
  defp taps(455),  do: [455, 453, 449, 444]
  defp taps(456),  do: [456, 454, 445, 433]
  defp taps(457),  do: [457, 454, 449, 446]
  defp taps(458),  do: [458, 453, 448, 445]
  defp taps(459),  do: [459, 457, 454, 447]
  defp taps(460),  do: [460, 459, 455, 451]
  defp taps(461),  do: [461, 460, 455, 454]
  defp taps(462),  do: [462, 457, 451, 450]
  defp taps(463),  do: [463, 456, 455, 452]
  defp taps(464),  do: [464, 460, 455, 441]
  defp taps(465),  do: [465, 463, 462, 457]
  defp taps(466),  do: [466, 460, 455, 452]
  defp taps(467),  do: [467, 466, 461, 456]
  defp taps(468),  do: [468, 464, 459, 453]
  defp taps(469),  do: [469, 467, 464, 460]
  defp taps(470),  do: [470, 468, 462, 461]
  defp taps(471),  do: [471, 469, 468, 465]
  defp taps(472),  do: [472, 470, 469, 461]
  defp taps(473),  do: [473, 470, 467, 465]
  defp taps(474),  do: [474, 465, 463, 456]
  defp taps(475),  do: [475, 471, 467, 466]
  defp taps(476),  do: [476, 475, 468, 466]
  defp taps(477),  do: [477, 470, 462, 461]
  defp taps(478),  do: [478, 477, 474, 472]
  defp taps(479),  do: [479, 475, 472, 470]
  defp taps(480),  do: [480, 473, 467, 464]
  defp taps(481),  do: [481, 480, 472, 471]
  defp taps(482),  do: [482, 477, 476, 473]
  defp taps(483),  do: [483, 479, 477, 474]
  defp taps(484),  do: [484, 483, 482, 470]
  defp taps(485),  do: [485, 479, 469, 468]
  defp taps(486),  do: [486, 481, 478, 472]
  defp taps(487),  do: [487, 485, 483, 478]
  defp taps(488),  do: [488, 487, 485, 484]
  defp taps(489),  do: [489, 484, 483, 480]
  defp taps(490),  do: [490, 485, 483, 481]
  defp taps(491),  do: [491, 488, 485, 480]
  defp taps(492),  do: [492, 491, 485, 484]
  defp taps(493),  do: [493, 490, 488, 483]
  defp taps(494),  do: [494, 493, 489, 481]
  defp taps(495),  do: [495, 494, 486, 480]
  defp taps(496),  do: [496, 494, 491, 480]
  defp taps(497),  do: [497, 493, 488, 486]
  defp taps(498),  do: [498, 495, 489, 487]
  defp taps(499),  do: [499, 494, 493, 488]
  defp taps(500),  do: [500, 499, 494, 490]
  defp taps(501),  do: [501, 499, 497, 496]
  defp taps(502),  do: [502, 498, 497, 494]
  defp taps(503),  do: [503, 502, 501, 500]
  defp taps(504),  do: [504, 502, 490, 483]
  defp taps(505),  do: [505, 500, 497, 493]
  defp taps(506),  do: [506, 501, 494, 491]
  defp taps(507),  do: [507, 504, 501, 494]
  defp taps(508),  do: [508, 505, 500, 495]
  defp taps(509),  do: [509, 506, 502, 501]
  defp taps(510),  do: [510, 501, 500, 498]
  defp taps(511),  do: [511, 509, 503, 501]
  defp taps(512),  do: [512, 510, 507, 504]
  defp taps(513),  do: [513, 505, 503, 500]
  defp taps(514),  do: [514, 511, 509, 507]
  defp taps(515),  do: [515, 511, 508, 501]
  defp taps(516),  do: [516, 514, 511, 509]
  defp taps(517),  do: [517, 515, 507, 505]
  defp taps(518),  do: [518, 516, 515, 507]
  defp taps(519),  do: [519, 517, 511, 507]
  defp taps(520),  do: [520, 509, 507, 503]
  defp taps(521),  do: [521, 519, 514, 512]
  defp taps(522),  do: [522, 518, 509, 507]
  defp taps(523),  do: [523, 521, 517, 510]
  defp taps(524),  do: [524, 523, 519, 515]
  defp taps(525),  do: [525, 524, 521, 519]
  defp taps(526),  do: [526, 525, 521, 517]
  defp taps(527),  do: [527, 526, 520, 518]
  defp taps(528),  do: [528, 526, 522, 517]
  defp taps(529),  do: [529, 528, 525, 522]
  defp taps(530),  do: [530, 527, 523, 520]
  defp taps(531),  do: [531, 529, 525, 519]
  defp taps(532),  do: [532, 529, 528, 522]
  defp taps(533),  do: [533, 531, 530, 529]
  defp taps(534),  do: [534, 533, 529, 527]
  defp taps(535),  do: [535, 533, 529, 527]
  defp taps(536),  do: [536, 533, 531, 529]
  defp taps(537),  do: [537, 536, 535, 527]
  defp taps(538),  do: [538, 537, 536, 533]
  defp taps(539),  do: [539, 535, 534, 529]
  defp taps(540),  do: [540, 537, 534, 529]
  defp taps(541),  do: [541, 537, 531, 528]
  defp taps(542),  do: [542, 540, 539, 533]
  defp taps(543),  do: [543, 538, 536, 532]
  defp taps(544),  do: [544, 538, 535, 531]
  defp taps(545),  do: [545, 539, 537, 532]
  defp taps(546),  do: [546, 545, 544, 538]
  defp taps(547),  do: [547, 543, 540, 534]
  defp taps(548),  do: [548, 545, 543, 538]
  defp taps(549),  do: [549, 546, 545, 533]
  defp taps(550),  do: [550, 546, 533, 529]
  defp taps(551),  do: [551, 550, 547, 542]
  defp taps(552),  do: [552, 550, 547, 532]
  defp taps(553),  do: [553, 550, 549, 542]
  defp taps(554),  do: [554, 551, 546, 543]
  defp taps(555),  do: [555, 551, 546, 545]
  defp taps(556),  do: [556, 549, 546, 540]
  defp taps(557),  do: [557, 552, 551, 550]
  defp taps(558),  do: [558, 553, 549, 544]
  defp taps(559),  do: [559, 557, 552, 550]
  defp taps(560),  do: [560, 554, 551, 549]
  defp taps(561),  do: [561, 558, 552, 550]
  defp taps(562),  do: [562, 560, 558, 551]
  defp taps(563),  do: [563, 561, 554, 549]
  defp taps(564),  do: [564, 563, 561, 558]
  defp taps(565),  do: [565, 564, 559, 554]
  defp taps(566),  do: [566, 564, 561, 560]
  defp taps(567),  do: [567, 563, 557, 556]
  defp taps(568),  do: [568, 558, 557, 551]
  defp taps(569),  do: [569, 568, 559, 557]
  defp taps(570),  do: [570, 563, 558, 552]
  defp taps(571),  do: [571, 569, 566, 561]
  defp taps(572),  do: [572, 571, 564, 560]
  defp taps(573),  do: [573, 569, 567, 563]
  defp taps(574),  do: [574, 569, 565, 560]
  defp taps(575),  do: [575, 572, 570, 569]
  defp taps(576),  do: [576, 573, 572, 563]
  defp taps(577),  do: [577, 575, 574, 569]
  defp taps(578),  do: [578, 562, 556, 555]
  defp taps(579),  do: [579, 572, 570, 567]
  defp taps(580),  do: [580, 579, 576, 574]
  defp taps(581),  do: [581, 575, 574, 568]
  defp taps(582),  do: [582, 579, 576, 571]
  defp taps(583),  do: [583, 581, 577, 575]
  defp taps(584),  do: [584, 581, 571, 570]
  defp taps(585),  do: [585, 583, 582, 577]
  defp taps(586),  do: [586, 584, 581, 579]
  defp taps(587),  do: [587, 586, 581, 576]
  defp taps(588),  do: [588, 577, 572, 571]
  defp taps(589),  do: [589, 586, 585, 579]
  defp taps(590),  do: [590, 588, 587, 578]
  defp taps(591),  do: [591, 587, 585, 582]
  defp taps(592),  do: [592, 591, 573, 568]
  defp taps(593),  do: [593, 588, 585, 584]
  defp taps(594),  do: [594, 586, 584, 583]
  defp taps(595),  do: [595, 594, 593, 586]
  defp taps(596),  do: [596, 592, 591, 590]
  defp taps(597),  do: [597, 588, 585, 583]
  defp taps(598),  do: [598, 597, 592, 591]
  defp taps(599),  do: [599, 593, 591, 590]
  defp taps(600),  do: [600, 599, 590, 589]
  defp taps(601),  do: [601, 600, 597, 589]
  defp taps(602),  do: [602, 596, 594, 591]
  defp taps(603),  do: [603, 600, 599, 597]
  defp taps(604),  do: [604, 600, 598, 589]
  defp taps(605),  do: [605, 600, 598, 595]
  defp taps(606),  do: [606, 602, 599, 591]
  defp taps(607),  do: [607, 600, 598, 595]
  defp taps(608),  do: [608, 606, 602, 585]
  defp taps(609),  do: [609, 601, 600, 597]
  defp taps(610),  do: [610, 602, 600, 599]
  defp taps(611),  do: [611, 609, 607, 601]
  defp taps(612),  do: [612, 607, 602, 598]
  defp taps(613),  do: [613, 609, 603, 594]
  defp taps(614),  do: [614, 613, 612, 607]
  defp taps(615),  do: [615, 614, 609, 608]
  defp taps(616),  do: [616, 614, 602, 597]
  defp taps(617),  do: [617, 612, 608, 607]
  defp taps(618),  do: [618, 615, 604, 598]
  defp taps(619),  do: [619, 614, 611, 610]
  defp taps(620),  do: [620, 619, 618, 611]
  defp taps(621),  do: [621, 616, 615, 609]
  defp taps(622),  do: [622, 612, 610, 605]
  defp taps(623),  do: [623, 614, 613, 612]
  defp taps(624),  do: [624, 617, 615, 612]
  defp taps(625),  do: [625, 620, 617, 613]
  defp taps(626),  do: [626, 623, 621, 613]
  defp taps(627),  do: [627, 622, 617, 613]
  defp taps(628),  do: [628, 626, 617, 616]
  defp taps(629),  do: [629, 627, 624, 623]
  defp taps(630),  do: [630, 628, 626, 623]
  defp taps(631),  do: [631, 625, 623, 617]
  defp taps(632),  do: [632, 629, 619, 613]
  defp taps(633),  do: [633, 632, 631, 626]
  defp taps(634),  do: [634, 631, 629, 627]
  defp taps(635),  do: [635, 631, 625, 621]
  defp taps(636),  do: [636, 632, 628, 623]
  defp taps(637),  do: [637, 636, 628, 623]
  defp taps(638),  do: [638, 637, 633, 632]
  defp taps(639),  do: [639, 636, 635, 629]
  defp taps(640),  do: [640, 638, 637, 626]
  defp taps(641),  do: [641, 640, 636, 622]
  defp taps(642),  do: [642, 636, 633, 632]
  defp taps(643),  do: [643, 641, 640, 632]
  defp taps(644),  do: [644, 634, 633, 632]
  defp taps(645),  do: [645, 641, 637, 634]
  defp taps(646),  do: [646, 635, 634, 633]
  defp taps(647),  do: [647, 646, 643, 642]
  defp taps(648),  do: [648, 647, 626, 625]
  defp taps(649),  do: [649, 648, 644, 638]
  defp taps(650),  do: [650, 644, 635, 632]
  defp taps(651),  do: [651, 646, 638, 637]
  defp taps(652),  do: [652, 647, 643, 641]
  defp taps(653),  do: [653, 646, 645, 643]
  defp taps(654),  do: [654, 649, 643, 640]
  defp taps(655),  do: [655, 653, 639, 638]
  defp taps(656),  do: [656, 646, 638, 637]
  defp taps(657),  do: [657, 656, 650, 649]
  defp taps(658),  do: [658, 651, 648, 646]
  defp taps(659),  do: [659, 657, 655, 644]
  defp taps(660),  do: [660, 657, 656, 648]
  defp taps(661),  do: [661, 657, 650, 649]
  defp taps(662),  do: [662, 659, 656, 650]
  defp taps(663),  do: [663, 655, 652, 649]
  defp taps(664),  do: [664, 662, 660, 649]
  defp taps(665),  do: [665, 661, 659, 654]
  defp taps(666),  do: [666, 664, 659, 656]
  defp taps(667),  do: [667, 664, 660, 649]
  defp taps(668),  do: [668, 658, 656, 651]
  defp taps(669),  do: [669, 667, 665, 664]
  defp taps(670),  do: [670, 669, 665, 664]
  defp taps(671),  do: [671, 669, 665, 662]
  defp taps(672),  do: [672, 667, 666, 661]
  defp taps(673),  do: [673, 666, 664, 663]
  defp taps(674),  do: [674, 671, 665, 660]
  defp taps(675),  do: [675, 674, 672, 669]
  defp taps(676),  do: [676, 675, 671, 664]
  defp taps(677),  do: [677, 674, 673, 669]
  defp taps(678),  do: [678, 675, 673, 663]
  defp taps(679),  do: [679, 676, 667, 661]
  defp taps(680),  do: [680, 679, 650, 645]
  defp taps(681),  do: [681, 678, 672, 670]
  defp taps(682),  do: [682, 681, 679, 675]
  defp taps(683),  do: [683, 682, 677, 672]
  defp taps(684),  do: [684, 681, 671, 666]
  defp taps(685),  do: [685, 684, 682, 681]
  defp taps(686),  do: [686, 684, 674, 673]
  defp taps(687),  do: [687, 682, 675, 673]
  defp taps(688),  do: [688, 682, 674, 669]
  defp taps(689),  do: [689, 686, 683, 681]
  defp taps(690),  do: [690, 687, 683, 680]
  defp taps(691),  do: [691, 689, 685, 678]
  defp taps(692),  do: [692, 687, 686, 678]
  defp taps(693),  do: [693, 691, 685, 678]
  defp taps(694),  do: [694, 691, 681, 677]
  defp taps(695),  do: [695, 694, 691, 686]
  defp taps(696),  do: [696, 694, 686, 673]
  defp taps(697),  do: [697, 689, 685, 681]
  defp taps(698),  do: [698, 690, 689, 688]
  defp taps(699),  do: [699, 698, 689, 684]
  defp taps(700),  do: [700, 698, 695, 694]
  defp taps(701),  do: [701, 699, 697, 685]
  defp taps(702),  do: [702, 701, 699, 695]
  defp taps(703),  do: [703, 702, 696, 691]
  defp taps(704),  do: [704, 701, 699, 692]
  defp taps(705),  do: [705, 704, 698, 697]
  defp taps(706),  do: [706, 697, 695, 692]
  defp taps(707),  do: [707, 702, 699, 692]
  defp taps(708),  do: [708, 706, 704, 703]
  defp taps(709),  do: [709, 708, 706, 705]
  defp taps(710),  do: [710, 709, 696, 695]
  defp taps(711),  do: [711, 704, 703, 700]
  defp taps(712),  do: [712, 709, 708, 707]
  defp taps(713),  do: [713, 706, 703, 696]
  defp taps(714),  do: [714, 709, 707, 701]
  defp taps(715),  do: [715, 714, 711, 708]
  defp taps(716),  do: [716, 706, 705, 704]
  defp taps(717),  do: [717, 716, 710, 701]
  defp taps(718),  do: [718, 717, 716, 713]
  defp taps(719),  do: [719, 711, 710, 707]
  defp taps(720),  do: [720, 718, 712, 709]
  defp taps(721),  do: [721, 720, 713, 712]
  defp taps(722),  do: [722, 721, 718, 707]
  defp taps(723),  do: [723, 717, 710, 707]
  defp taps(724),  do: [724, 719, 716, 711]
  defp taps(725),  do: [725, 720, 719, 716]
  defp taps(726),  do: [726, 725, 722, 721]
  defp taps(727),  do: [727, 721, 719, 716]
  defp taps(728),  do: [728, 726, 725, 724]
  defp taps(729),  do: [729, 726, 724, 718]
  defp taps(730),  do: [730, 726, 715, 711]
  defp taps(731),  do: [731, 729, 725, 723]
  defp taps(732),  do: [732, 729, 728, 725]
  defp taps(733),  do: [733, 731, 726, 725]
  defp taps(734),  do: [734, 724, 721, 720]
  defp taps(735),  do: [735, 733, 728, 727]
  defp taps(736),  do: [736, 730, 728, 723]
  defp taps(737),  do: [737, 736, 733, 732]
  defp taps(738),  do: [738, 730, 729, 727]
  defp taps(739),  do: [739, 731, 723, 721]
  defp taps(740),  do: [740, 737, 728, 716]
  defp taps(741),  do: [741, 738, 733, 732]
  defp taps(742),  do: [742, 741, 738, 730]
  defp taps(743),  do: [743, 742, 731, 730]
  defp taps(744),  do: [744, 743, 733, 731]
  defp taps(745),  do: [745, 740, 738, 737]
  defp taps(746),  do: [746, 738, 733, 728]
  defp taps(747),  do: [747, 743, 741, 737]
  defp taps(748),  do: [748, 744, 743, 733]
  defp taps(749),  do: [749, 748, 743, 742]
  defp taps(750),  do: [750, 746, 741, 734]
  defp taps(751),  do: [751, 750, 748, 740]
  defp taps(752),  do: [752, 749, 732, 731]
  defp taps(753),  do: [753, 748, 745, 740]
  defp taps(754),  do: [754, 742, 740, 735]
  defp taps(755),  do: [755, 754, 745, 743]
  defp taps(756),  do: [756, 755, 747, 740]
  defp taps(757),  do: [757, 756, 751, 750]
  defp taps(758),  do: [758, 757, 746, 741]
  defp taps(759),  do: [759, 757, 756, 750]
  defp taps(760),  do: [760, 757, 747, 734]
  defp taps(761),  do: [761, 760, 759, 758]
  defp taps(762),  do: [762, 761, 755, 745]
  defp taps(763),  do: [763, 754, 749, 747]
  defp taps(764),  do: [764, 761, 759, 758]
  defp taps(765),  do: [765, 760, 755, 754]
  defp taps(766),  do: [766, 757, 747, 744]
  defp taps(767),  do: [767, 763, 760, 759]
  defp taps(768),  do: [768, 764, 751, 749]
  defp taps(769),  do: [769, 763, 762, 760]
  defp taps(770),  do: [770, 768, 765, 756]
  defp taps(771),  do: [771, 765, 756, 754]
  defp taps(772),  do: [772, 767, 766, 764]
  defp taps(773),  do: [773, 767, 765, 763]
  defp taps(774),  do: [774, 767, 760, 758]
  defp taps(775),  do: [775, 771, 769, 768]
  defp taps(776),  do: [776, 773, 764, 759]
  defp taps(777),  do: [777, 776, 767, 761]
  defp taps(778),  do: [778, 775, 762, 759]
  defp taps(779),  do: [779, 776, 771, 769]
  defp taps(780),  do: [780, 775, 772, 764]
  defp taps(781),  do: [781, 779, 765, 764]
  defp taps(782),  do: [782, 780, 779, 773]
  defp taps(783),  do: [783, 782, 776, 773]
  defp taps(784),  do: [784, 778, 775, 771]
  defp taps(785),  do: [785, 780, 776, 775]
  defp taps(786),  do: [786, 782, 780, 771]
  defp taps(1024), do: [1024, 1015, 1002, 1001]
  defp taps(2048), do: [2048, 2035, 2034, 2029]
  defp taps(4096), do: [4096, 4095, 4081, 4069]
  defp taps(size) do
    raise ArgumentError, message: "no entry for size #{size} found in the table of maximum-cycle LFSR taps"
  end
end
