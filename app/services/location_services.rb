class LocationServices

  class << self
    def getStates(phone)
      firstNumbers = (['55', '33', '81'].include? phone[3,2]) ? phone[3,2] : phone[3,3]
      searchStates(firstNumbers.to_i)
    end

    private

    def searchStates(firstNumbers)
      states = [
        { lada: 449, name: 'Aguascalientes' }, { lada: 458, name: 'Aguascalientes' }, { lada: 465, name: 'Aguascalientes' }, { lada: 495, name: 'Aguascalientes' },
        { lada: 496, name: 'Aguascalientes' }, { lada: 615, name: 'Baja California' }, { lada: 616, name: 'Baja California' }, { lada: 646, name: 'Baja California' },
        { lada: 653, name: 'Baja California' }, { lada: 658, name: 'Baja California' }, { lada: 661, name: 'Baja California' }, { lada: 664, name: 'Baja California' },
        { lada: 665, name: 'Baja California' }, { lada: 686, name: 'Baja California' }, { lada: 612, name: 'Baja California Sur' },
        { lada: 613, name: 'Baja California Sur' }, { lada: 615, name: 'Baja California Sur' }, { lada: 624, name: 'Baja California Sur' },
        { lada: 913, name: 'Campeche' }, { lada: 938, name: 'Campeche' }, { lada: 981, name: 'Campeche' }, { lada: 982, name: 'Campeche' },
        { lada: 983, name: 'Campeche' }, { lada: 996, name: 'Campeche' }, { lada: 916, name: 'Chiapas' }, { lada: 917, name: 'Chiapas' },
        { lada: 918, name: 'Chiapas' }, { lada: 919, name: 'Chiapas' }, { lada: 932, name: 'Chiapas' }, { lada: 934, name: 'Chiapas' }, { lada: 961, name: 'Chiapas' },
        { lada: 962, name: 'Chiapas' }, { lada: 963, name: 'Chiapas' }, { lada: 964, name: 'Chiapas' }, { lada: 965, name: 'Chiapas' }, { lada: 966, name: 'Chiapas' },
        { lada: 967, name: 'Chiapas' }, { lada: 968, name: 'Chiapas' }, { lada: 992, name: 'Chiapas' }, { lada: 994, name: 'Chiapas' }, { lada: 614, name: 'Chihuahua' },
        { lada: 621, name: 'Chihuahua' }, { lada: 625, name: 'Chihuahua' }, { lada: 626, name: 'Chihuahua' }, { lada: 627, name: 'Chihuahua' },
        { lada: 628, name: 'Chihuahua' }, { lada: 629, name: 'Chihuahua' }, { lada: 635, name: 'Chihuahua' }, { lada: 636, name: 'Chihuahua' },
        { lada: 639, name: 'Chihuahua' }, { lada: 648, name: 'Chihuahua' }, { lada: 649, name: 'Chihuahua' }, { lada: 652, name: 'Chihuahua' },
        { lada: 656, name: 'Chihuahua' }, { lada: 659, name: 'Chihuahua' }, { lada: 842, name: 'Coahuila' }, { lada: 844, name: 'Coahuila' },
        { lada: 861, name: 'Coahuila' }, { lada: 862, name: 'Coahuila' }, { lada: 864, name: 'Coahuila' }, { lada: 866, name: 'Coahuila' },
        { lada: 867, name: 'Coahuila' }, { lada: 869, name: 'Coahuila' }, { lada: 871, name: 'Coahuila' }, { lada: 872, name: 'Coahuila' },{ lada: 873, name: 'Coahuila' },
        { lada: 877, name: 'Coahuila' }, { lada: 878, name: 'Coahuila' }, { lada: 312, name: 'Colima' }, { lada: 313, name: 'Colima' }, { lada: 314, name: 'Colima' },
        { lada: 618, name: 'Durango' }, { lada: 629, name: 'Durango' }, { lada: 649, name: 'Durango' }, { lada: 671, name: 'Durango' }, { lada: 674, name: 'Durango' },
        { lada: 675, name: 'Durango' }, { lada: 676, name: 'Durango' }, { lada: 677, name: 'Durango' }, { lada: 871, name: 'Durango' }, { lada: 872, name: 'Durango' },
        { lada: 55, name: 'CDMX' }, { lada: 427, name: 'Estado de México' }, { lada: 712, name: 'Estado de México' }, { lada: 588, name: 'Estado de México' },
        { lada: 591, name: 'Estado de México' }, { lada: 592, name: 'Estado de México' }, { lada: 593, name: 'Estado de México' }, { lada: 594, name: 'Estado de México' },
        { lada: 595, name: 'Estado de México' }, { lada: 596, name: 'Estado de México' }, { lada: 597, name: 'Estado de México' }, { lada: 599, name: 'Estado de México' },
        { lada: 711, name: 'Estado de México' }, { lada: 713, name: 'Estado de México' }, { lada: 714, name: 'Estado de México' }, { lada: 716, name: 'Estado de México' },
        { lada: 717, name: 'Estado de México' }, { lada: 718, name: 'Estado de México' }, { lada: 719, name: 'Estado de México' }, { lada: 721, name: 'Estado de México' },
        { lada: 722, name: 'Estado de México' }, { lada: 723, name: 'Estado de México' }, { lada: 724, name: 'Estado de México' }, { lada: 725, name: 'Estado de México' },
        { lada: 726, name: 'Estado de México' }, { lada: 728, name: 'Estado de México' }, { lada: 743, name: 'Estado de México' }, { lada: 761, name: 'Estado de México' },
        { lada: 767, name: 'Estado de México' }, { lada: 352, name: 'Guanajuato' }, { lada: 411, name: 'Guanajuato' }, { lada: 412, name: 'Guanajuato' },
        { lada: 413, name: 'Guanajuato' }, { lada: 415, name: 'Guanajuato' }, { lada: 417, name: 'Guanajuato' }, { lada: 418, name: 'Guanajuato' },
        { lada: 419, name: 'Guanajuato' }, { lada: 421, name: 'Guanajuato' }, { lada: 428, name: 'Guanajuato' }, { lada: 429, name: 'Guanajuato' },
        { lada: 432, name: 'Guanajuato' }, { lada: 438, name: 'Guanajuato' }, { lada: 442, name: 'Guanajuato' }, { lada: 445, name: 'Guanajuato' },
        { lada: 456, name: 'Guanajuato' }, { lada: 461, name: 'Guanajuato' }, { lada: 462, name: 'Guanajuato' }, { lada: 464, name: 'Guanajuato' },
        { lada: 466, name: 'Guanajuato' }, { lada: 468, name: 'Guanajuato' }, { lada: 469, name: 'Guanajuato' }, { lada: 472, name: 'Guanajuato' },
        { lada: 473, name: 'Guanajuato' }, { lada: 476, name: 'Guanajuato' }, { lada: 477, name: 'Guanajuato' }, { lada: 721, name: 'Guerrero' },
        { lada: 727, name: 'Guerrero' }, { lada: 732, name: 'Guerrero' }, { lada: 733, name: 'Guerrero' }, { lada: 736, name: 'Guerrero' }, { lada: 741, name: 'Guerrero' },
        { lada: 742, name: 'Guerrero' }, { lada: 744, name: 'Guerrero' }, { lada: 745, name: 'Guerrero' }, { lada: 747, name: 'Guerrero' }, { lada: 753, name: 'Guerrero' },
        { lada: 754, name: 'Guerrero' }, { lada: 755, name: 'Guerrero' }, { lada: 756, name: 'Guerrero' }, { lada: 757, name: 'Guerrero' }, { lada: 758, name: 'Guerrero' },
        { lada: 762, name: 'Guerrero' }, { lada: 767, name: 'Guerrero' }, { lada: 781, name: 'Guerrero' }, { lada: 427, name: 'Hidalgo' }, { lada: 441, name: 'Hidalgo' },
        { lada: 483, name: 'Hidalgo' }, { lada: 591, name: 'Hidalgo' }, { lada: 736, name: 'Hidalgo' }, { lada: 738, name: 'Hidalgo' }, { lada: 743, name: 'Hidalgo' },
        { lada: 745, name: 'Hidalgo' }, { lada: 746, name: 'Hidalgo' }, { lada: 748, name: 'Hidalgo' }, { lada: 759, name: 'Hidalgo' }, { lada: 761, name: 'Hidalgo' },
        { lada: 763, name: 'Hidalgo' }, { lada: 771, name: 'Hidalgo' }, { lada: 772, name: 'Hidalgo' }, { lada: 773, name: 'Hidalgo' }, { lada: 774, name: 'Hidalgo' },
        { lada: 775, name: 'Hidalgo' }, { lada: 776, name: 'Hidalgo' }, { lada: 778, name: 'Hidalgo' }, { lada: 779, name: 'Hidalgo' }, { lada: 789, name: 'Hidalgo' },
        { lada: 791, name: 'Hidalgo' }, { lada: 33, name: 'Jalisco' }, { lada: 312, name: 'Jalisco' }, { lada: 315, name: 'Jalisco' }, { lada: 316, name: 'Jalisco' },
        { lada: 317, name: 'Jalisco' }, { lada: 321, name: 'Jalisco' }, { lada: 322, name: 'Jalisco' }, { lada: 326, name: 'Jalisco' }, { lada: 341, name: 'Jalisco' },
        { lada: 342, name: 'Jalisco' }, { lada: 343, name: 'Jalisco' }, { lada: 344, name: 'Jalisco' }, { lada: 345, name: 'Jalisco' }, { lada: 346, name: 'Jalisco' },
        { lada: 347, name: 'Jalisco' }, { lada: 348, name: 'Jalisco' }, { lada: 349, name: 'Jalisco' }, { lada: 354, name: 'Jalisco' }, { lada: 357, name: 'Jalisco' },
        { lada: 358, name: 'Jalisco' }, { lada: 371, name: 'Jalisco' }, { lada: 372, name: 'Jalisco' }, { lada: 373, name: 'Jalisco' }, { lada: 374, name: 'Jalisco' },
        { lada: 375, name: 'Jalisco' }, { lada: 376, name: 'Jalisco' }, { lada: 377, name: 'Jalisco' }, { lada: 378, name: 'Jalisco' }, { lada: 382, name: 'Jalisco' },
        { lada: 384, name: 'Jalisco' }, { lada: 385, name: 'Jalisco' }, { lada: 386, name: 'Jalisco' }, { lada: 387, name: 'Jalisco' }, { lada: 388, name: 'Jalisco' },
        { lada: 391, name: 'Jalisco' }, { lada: 392, name: 'Jalisco' }, { lada: 393, name: 'Jalisco' }, { lada: 395, name: 'Jalisco' }, { lada: 424, name: 'Jalisco' },
        { lada: 431, name: 'Jalisco' }, { lada: 437, name: 'Jalisco' }, { lada: 457, name: 'Jalisco' }, { lada: 474, name: 'Jalisco' }, { lada: 475, name: 'Jalisco' },
        { lada: 495, name: 'Jalisco' }, { lada: 496, name: 'Jalisco' }, { lada: 499, name: 'Jalisco' }, { lada: 311, name: 'Nayarit' }, { lada: 319, name: 'Nayarit' },
        { lada: 322, name: 'Nayarit' }, { lada: 323, name: 'Nayarit' }, { lada: 324, name: 'Nayarit' }, { lada: 325, name: 'Nayarit' }, { lada: 327, name: 'Nayarit' },
        { lada: 329, name: 'Nayarit' }, { lada: 389, name: 'Nayarit' }, { lada: 81, name: 'Nuevo León' }, { lada: 488, name: 'Nuevo León' },
        { lada: 821, name: 'Nuevo León' }, { lada: 823, name: 'Nuevo León' }, { lada: 824, name: 'Nuevo León' }, { lada: 825, name: 'Nuevo León' },
        { lada: 826, name: 'Nuevo León' }, { lada: 828, name: 'Nuevo León' }, { lada: 829, name: 'Nuevo León' }, { lada: 867, name: 'Nuevo León' },
        { lada: 873, name: 'Nuevo León' }, { lada: 892, name: 'Nuevo León' }, { lada: 313, name: 'Michoacán' }, { lada: 328, name: 'Michoacán' },
        { lada: 351, name: 'Michoacán' }, { lada: 352, name: 'Michoacán' }, { lada: 353, name: 'Michoacán' }, { lada: 354, name: 'Michoacán' },
        { lada: 355, name: 'Michoacán' }, { lada: 356, name: 'Michoacán' }, { lada: 359, name: 'Michoacán' }, { lada: 381, name: 'Michoacán' },
        { lada: 383, name: 'Michoacán' }, { lada: 393, name: 'Michoacán' }, { lada: 394, name: 'Michoacán' }, { lada: 421, name: 'Michoacán' },
        { lada: 422, name: 'Michoacán' }, { lada: 423, name: 'Michoacán' }, { lada: 424, name: 'Michoacán' }, { lada: 425, name: 'Michoacán' },
        { lada: 426, name: 'Michoacán' }, { lada: 434, name: 'Michoacán' }, { lada: 435, name: 'Michoacán' }, { lada: 436, name: 'Michoacán' },
        { lada: 438, name: 'Michoacán' }, { lada: 443, name: 'Michoacán' }, { lada: 447, name: 'Michoacán' }, { lada: 451, name: 'Michoacán' },
        { lada: 452, name: 'Michoacán' }, { lada: 453, name: 'Michoacán' }, { lada: 454, name: 'Michoacán' }, { lada: 455, name: 'Michoacán' },
        { lada: 459, name: 'Michoacán' }, { lada: 471, name: 'Michoacán' }, { lada: 711, name: 'Michoacán' }, { lada: 715, name: 'Michoacán' },
        { lada: 753, name: 'Michoacán' }, { lada: 786, name: 'Michoacán' }, { lada: 731, name: 'Morelos' }, { lada: 734, name: 'Morelos' }, { lada: 735, name: 'Morelos' },
        { lada: 737, name: 'Morelos' }, { lada: 739, name: 'Morelos' }, { lada: 751, name: 'Morelos' }, { lada: 769, name: 'Morelos' }, { lada: 777, name: 'Morelos' },
        { lada: 236, name: 'Oaxaca' }, { lada: 274, name: 'Oaxaca' }, { lada: 281, name: 'Oaxaca' }, { lada: 283, name: 'Oaxaca' }, { lada: 287, name: 'Oaxaca' },
        { lada: 741, name: 'Oaxaca' }, { lada: 757, name: 'Oaxaca' }, { lada: 924, name: 'Oaxaca' }, { lada: 951, name: 'Oaxaca' }, { lada: 953, name: 'Oaxaca' },
        { lada: 954, name: 'Oaxaca' }, { lada: 958, name: 'Oaxaca' }, { lada: 971, name: 'Oaxaca' }, { lada: 972, name: 'Oaxaca' }, { lada: 994, name: 'Oaxaca' },
        { lada: 995, name: 'Oaxaca' }, { lada: 222, name: 'Puebla' }, { lada: 223, name: 'Puebla' }, { lada: 224, name: 'Puebla' }, { lada: 227, name: 'Puebla' },
        { lada: 231, name: 'Puebla' }, { lada: 232, name: 'Puebla' }, { lada: 233, name: 'Puebla' }, { lada: 236, name: 'Puebla' }, { lada: 237, name: 'Puebla' },
        { lada: 238, name: 'Puebla' }, { lada: 243, name: 'Puebla' }, { lada: 244, name: 'Puebla' }, { lada: 245, name: 'Puebla' }, { lada: 248, name: 'Puebla' },
        { lada: 249, name: 'Puebla' }, { lada: 275, name: 'Puebla' }, { lada: 276, name: 'Puebla' }, { lada: 282, name: 'Puebla' }, { lada: 746, name: 'Puebla' },
        { lada: 764, name: 'Puebla' }, { lada: 776, name: 'Puebla' }, { lada: 797, name: 'Puebla' }, { lada: 953, name: 'Puebla' }, { lada: 414, name: 'Querétaro' },
        { lada: 419, name: 'Querétaro' }, { lada: 427, name: 'Querétaro' }, { lada: 441, name: 'Querétaro' }, { lada: 442, name: 'Querétaro' },
        { lada: 448, name: 'Querétaro' }, { lada: 487, name: 'Querétaro' }, { lada: 761, name: 'Querétaro' }, { lada: 983, name: 'Quintana Roo' },
        { lada: 984, name: 'Quintana Roo' }, { lada: 987, name: 'Quintana Roo' }, { lada: 997, name: 'Quintana Roo' }, { lada: 998, name: 'Quintana Roo' },
        { lada: 444, name: 'San Luis Potosí' }, { lada: 458, name: 'San Luis Potosí' }, { lada: 481, name: 'San Luis Potosí' }, { lada: 482, name: 'San Luis Potosí' },
        { lada: 483, name: 'San Luis Potosí' }, { lada: 485, name: 'San Luis Potosí' }, { lada: 486, name: 'San Luis Potosí' }, { lada: 487, name: 'San Luis Potosí' },
        { lada: 488, name: 'San Luis Potosí' }, { lada: 489, name: 'San Luis Potosí' }, { lada: 496, name: 'San Luis Potosí' }, { lada: 845, name: 'San Luis Potosí' },
        { lada: 667, name: 'Sinaloa' }, { lada: 668, name: 'Sinaloa' }, { lada: 669, name: 'Sinaloa' }, { lada: 672, name: 'Sinaloa' }, { lada: 673, name: 'Sinaloa' },
        { lada: 687, name: 'Sinaloa' }, { lada: 694, name: 'Sinaloa' }, { lada: 695, name: 'Sinaloa' }, { lada: 696, name: 'Sinaloa' }, { lada: 697, name: 'Sinaloa' },
        { lada: 698, name: 'Sinaloa' }, { lada: 622, name: 'Sonora' }, { lada: 623, name: 'Sonora' }, { lada: 631, name: 'Sonora' }, { lada: 632, name: 'Sonora' },
        { lada: 633, name: 'Sonora' }, { lada: 634, name: 'Sonora' }, { lada: 637, name: 'Sonora' }, { lada: 638, name: 'Sonora' }, { lada: 641, name: 'Sonora' },
        { lada: 642, name: 'Sonora' }, { lada: 643, name: 'Sonora' }, { lada: 644, name: 'Sonora' }, { lada: 645, name: 'Sonora' }, { lada: 647, name: 'Sonora' },
        { lada: 651, name: 'Sonora' }, { lada: 653, name: 'Sonora' }, { lada: 662, name: 'Sonora' }, { lada: 913, name: 'Tabasco' }, { lada: 914, name: 'Tabasco' },
        { lada: 916, name: 'Tabasco' }, { lada: 917, name: 'Tabasco' }, { lada: 923, name: 'Tabasco' }, { lada: 932, name: 'Tabasco' }, { lada: 933, name: 'Tabasco' },
        { lada: 934, name: 'Tabasco' }, { lada: 936, name: 'Tabasco' }, { lada: 937, name: 'Tabasco' }, { lada: 993, name: 'Tabasco' }, { lada: 482, name: 'Tamaulipas' },
        { lada: 831, name: 'Tamaulipas' }, { lada: 832, name: 'Tamaulipas' }, { lada: 833, name: 'Tamaulipas' }, { lada: 834, name: 'Tamaulipas' },
        { lada: 835, name: 'Tamaulipas' }, { lada: 836, name: 'Tamaulipas' }, { lada: 841, name: 'Tamaulipas' }, { lada: 867, name: 'Tamaulipas' },
        { lada: 868, name: 'Tamaulipas' }, { lada: 891, name: 'Tamaulipas' }, { lada: 894, name: 'Tamaulipas' }, { lada: 897, name: 'Tamaulipas' },
        { lada: 899, name: 'Tamaulipas' }, { lada: 223, name: 'Tlaxcala' }, { lada: 241, name: 'Tlaxcala' }, { lada: 246, name: 'Tlaxcala' }, { lada: 247, name: 'Tlaxcala' },
        { lada: 248, name: 'Tlaxcala' }, { lada: 276, name: 'Tlaxcala' }, { lada: 748, name: 'Tlaxcala' }, { lada: 749, name: 'Tlaxcala' }, { lada: 225, name: 'Veracruz' },
        { lada: 226, name: 'Veracruz' }, { lada: 228, name: 'Veracruz' }, { lada: 229, name: 'Veracruz' }, { lada: 232, name: 'Veracruz' }, { lada: 235, name: 'Veracruz' },
        { lada: 271, name: 'Veracruz' }, { lada: 272, name: 'Veracruz' }, { lada: 273, name: 'Veracruz' }, { lada: 274, name: 'Veracruz' }, { lada: 278, name: 'Veracruz' },
        { lada: 279, name: 'Veracruz' }, { lada: 282, name: 'Veracruz' }, { lada: 283, name: 'Veracruz' }, { lada: 284, name: 'Veracruz' }, { lada: 285, name: 'Veracruz' },
        { lada: 287, name: 'Veracruz' }, { lada: 288, name: 'Veracruz' }, { lada: 294, name: 'Veracruz' }, { lada: 296, name: 'Veracruz' }, { lada: 297, name: 'Veracruz' },
        { lada: 489, name: 'Veracruz' }, { lada: 746, name: 'Veracruz' }, { lada: 765, name: 'Veracruz' }, { lada: 766, name: 'Veracruz' }, { lada: 768, name: 'Veracruz' },
        { lada: 774, name: 'Veracruz' }, { lada: 782, name: 'Veracruz' }, { lada: 783, name: 'Veracruz' }, { lada: 784, name: 'Veracruz' }, { lada: 785, name: 'Veracruz' },
        { lada: 789, name: 'Veracruz' }, { lada: 833, name: 'Veracruz' }, { lada: 846, name: 'Veracruz' }, { lada: 921, name: 'Veracruz' }, { lada: 922, name: 'Veracruz' },
        { lada: 923, name: 'Veracruz' }, { lada: 924, name: 'Veracruz' }, { lada: 969, name: 'Yucatán' }, { lada: 985, name: 'Yucatán' }, { lada: 986, name: 'Yucatán' },
        { lada: 988, name: 'Yucatán' }, { lada: 991, name: 'Yucatán' }, { lada: 997, name: 'Yucatán' }, { lada: 999, name: 'Yucatán' }, { lada: 346, name: 'Zacatecas' },
        { lada: 433, name: 'Zacatecas' }, { lada: 437, name: 'Zacatecas' }, { lada: 457, name: 'Zacatecas' }, { lada: 458, name: 'Zacatecas' }, { lada: 463, name: 'Zacatecas' },
        { lada: 467, name: 'Zacatecas' }, { lada: 478, name: 'Zacatecas' }, { lada: 492, name: 'Zacatecas' }, { lada: 493, name: 'Zacatecas' }, { lada: 494, name: 'Zacatecas' },
        { lada: 496, name: 'Zacatecas' }, { lada: 498, name: 'Zacatecas' }, { lada: 499, name: 'Zacatecas' }, { lada: 842, name: 'Zacatecas' }
      ]
      states = states.select { |state| state[:lada] == firstNumbers }
      filterLocationKey(states)
    end

    def filterLocationKey(location_array)
      name_array = []
      if location_array.count.positive?
        location_array.each do |location|
          name_array.push(location[:name])
        end
      else
        name_array.push('No detectado en México')
      end
      name_array
    end
  end
end
