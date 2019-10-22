function B = addMargin(A)

B = ones(276,276,3);
B = 255 * B;

B(5:272,5:272,:) = A;
B = uint8(B);

end